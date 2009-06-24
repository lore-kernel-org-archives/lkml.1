Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZFXWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZFXWh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFXWht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:37:49 -0400
Received: from outbound-mail-04.bluehost.com ([69.89.21.14]:41943 "HELO
	outbound-mail-04.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751523AbZFXWhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:37:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dH3IYuT+jnxjxrczMyh7RCjX4yM+axPLPtiwXlD/HC1fbDoMQ3/Vxpu8elahD0LcxcGUZ3udHwsdfM9+YG89lm1Fnro1jly77QgsCF2sz5ROuMUZxQ0ysjVfYQpbtK2m;
Date: Wed, 24 Jun 2009 15:37:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: get root CRS before scan child -v2
Message-ID: <20090624153748.2ba17aea@jbarnes-g45>
In-Reply-To: <4A429F29.4070007@kernel.org>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A429F29.4070007@kernel.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 14:48:25 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> so we could remove adjust_transparent_bridge_resources..
> 
> and give x86_pci_root_bus_res_quirks chance when _CRS is not used or
> not there.
> 
> v2: add print out if pci conf reading for res is used for root
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Do you think this is generally safe?  I was hoping we could do
something more complete, like making the code handle arbitrary numbers
of resources in _CRS.  Hacking that together now.

-- 
Jesse Barnes, Intel Open Source Technology Center
