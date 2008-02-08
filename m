Return-Path: <linux-kernel-owner+w=401wt.eu-S934094AbYBHF6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbYBHF6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYBHF62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:58:28 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60548 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbYBHF62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:58:28 -0500
Date: Fri, 8 Feb 2008 06:58:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de, jgarzik@pobox.com
Subject: Re: [PATCH] isdn: fix section mismatch warning in enpci_card_msg
Message-ID: <20080208055833.GA26183@uranus.ravnborg.org>
References: <20080201133838.GA13349@uranus.ravnborg.org> <1201873364-13475-3-git-send-email-sam@ravnborg.org> <20080207.182040.196977279.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207.182040.196977279.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 06:20:40PM -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri,  1 Feb 2008 14:42:42 +0100
> 
> > Fix following warnings:
> > WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf50): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()
> > WARNING: drivers/isdn/hisax/built-in.o(.text+0x3cf85): Section mismatch in reference from the function enpci_card_msg() to the function .devinit.text:Amd7930_init()
> > 
> > enpci_card_msg() can be called outside __devinit context
> > referenced function should not be annotated __devinit.
> > 
> > Remove annotation of Amd7930_init to fix this.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> 
> Applied, thanks.

Hi David - did you apply only this
or all 5 patches?
I can resend if you prefer with Karsten's ack included.

PS. Do you usual take isdn patches?

	Sam
