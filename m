Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXHUGhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXHUGhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXHUGg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:36:56 -0400
Received: from smtp122.sbc.mail.re3.yahoo.com ([66.196.96.95]:35980 "HELO
	smtp122.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752539AbXHUGgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:36:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sbGc2dYpR5zmncT7ykNYueEuyZ9WVORIjoj3QNSIcGmZtnsQgD8aAf0L/QbCFdM45IwVXKL2OGyt1PMxC+knKyktjjt7V2jEYwEGXKjLNGATliZrFpxvGn3N0Qbde+R44a3ahN0uYHopBemzKwL/rtJEpYFfGQ7K8ID3TDmiLvA=  ;
X-YMail-OSG: .rEYTSIVM1kAfVYBZEDTxDkTScSDlfYB.UvrYj44HgalhzslyXGsTL5_u6VJt_5fGJiH_80vUw--
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
Date: Mon, 20 Aug 2007 23:34:37 -0700
User-Agent: KMail/1.9.6
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
References: <46C098FD.1030601@googlemail.com> <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org> <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708202334.38261.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007, Linus Torvalds wrote:
> 
> On Mon, 20 Aug 2007, Linus Torvalds wrote:
> > 
> > Ok. But in the meantime, I really think we should just revert the code 
> > that causes a known regression.
> 
> Side note: one reason I'm interested in this is that my mac mini (now used 
> by the kids) has had a very flaky USB mouse lately. Is it related? I have 
> no idea, and probably not, but as a result I'm very interested in any USB 
> regressions. There's *something* rotten with that mouse, and while it 
> could be the mouse itself going bad, I think it started happening only 
> after updating that machine to 2.6.23-rc1.

Try disabling USB_SUSPEND ... the rather aggressive powersave
mechanism (autosuspend defaulting to always ON) has made lots
of trouble.  I think that default will change...

- Dave
