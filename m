Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbZFYQmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbZFYQmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZFYQly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:41:54 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:51745 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752133AbZFYQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:41:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=p1ZXv4xBjSIxHEPscR1Qgj6JjcWoXR9TDfpCnCx+s5FsoRui5ddTt8bKGibqQT9nSMw5+yu0ENnG6kgh4eyXDbEj0MfX0FqOAehbTxQqA8GijBMXIAZqlXuqLT2yCqGa;
Date: Thu, 25 Jun 2009 09:41:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andres Freund <andres@anarazel.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [BUG] GM45 blanks shortly after boot in 2.6.30-git
Message-ID: <20090625094152.179740c0@jbarnes-g45>
In-Reply-To: <4A43359F.3030208@anarazel.de>
References: <4A43359F.3030208@anarazel.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 10:30:23 +0200
Andres Freund <andres@anarazel.de> wrote:

> Hi,
> 
> Somewhere between:
> 03347e2592078a90df818670fddf97a33eec70fb (2.6.30 + 5415 commits)
> and
> c82e6d450fda56cb2d4f68534173d3cd11b32f9f (2.6.30 + 8722 commits)
> my Laptop (Lenovo T500) with an Intel GM45 graphics card blanks
> display during boot (before starting with initramfs) , stops
> responding to anything (i.e. no caps-lock light) and shows no further
> activity (i.e. no hdd activity).
> 
> Before the blank I did not see any sign of a backtrace or similar,
> but its hard to say there wasn't any. Unfortunately atm I don't have
> another computer nearby, so I could not get a network console output
> yet.

So the i915 driver probably loaded and turned off your display, either
by programming a bad mode or misdetecting something else...

> Any other information needed?

Can you try loading the drm module with debug=1?  That should give us
some more info about what's going on.

A bisect would help too of course...

-- 
Jesse Barnes, Intel Open Source Technology Center
