Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZCTBuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZCTBuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbZCTBtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:49:55 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:51634 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761053AbZCTBty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:49:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qUSQ6eppsn18J37eWfK0dyQ3kthaF1aWpw7RAhhmFURVXNmdXXehhSbqnDK4GXCX5VLFU/GAwhEh8eE0WGUa/fuHAHjqKspLqjctKA7w+EKjGn1MvFZlnkibli6xuA4R;
Date: Thu, 19 Mar 2009 18:49:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, linux-pci@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] pci: fix kexec with power state D3
Message-ID: <20090319184948.44bf5e9a@hobbes.lan>
In-Reply-To: <20090308110835.GB27811@elte.hu>
References: <49B1F934.5050006@kernel.org>
	<20090308101530.GB14133@elte.hu>
	<200903081128.35970.rjw@sisk.pl>
	<200903081133.33020.rjw@sisk.pl>
	<20090308110835.GB27811@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And, quite frankly, I'm not sure if users will be happy with 
> > the $subject patch, because it _really_ breaks things (well, 
> > the kexec users who don't use suspend might be, but surely 
> > suspend users who don't use kexec won't).
> 
> Please note that i havent reviewed the patches and i did not 
> take any sides in the discussion - i just flagged the maintainer 
> ping-pong. As long as we pick one of the patches (or a third 
> one) within a bound amount of time we should be fine :)

I'll defer to Rafael here; he's been working the most in this area.
The changelog wasn't very complete for the original patch, but it
sounds like in the kexec case the newly booted kernel will get an igb
device in D3 which it can't handle?  That really does sound like a
driver bug, not something we should mess with in the core.

-- 
Jesse Barnes, Intel Open Source Technology Center
