Return-Path: <linux-kernel-owner+w=401wt.eu-S934548AbXGQUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548AbXGQUsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936319AbXGQUom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:44:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:34961 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934735AbXGQUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IWSBIl/XbXEP+CoZp45wv3DEPxu1+gP5tnMzx7mEn6U9pQYJPeAkkeYVabsdi4GF3/51f4D/8tPpw2qLQ55Aqe2k7CMu9a6n71GfRAFRuMuuq2RTYfi1ZelO0fU8KBcvV7Z4Bdi7EoUm7OQB8u/OHOY8tiiyiLeRX3YcANOjtlk=
Subject: Re: VESAFB CUSTOM RESOLUTION
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Sasa Ostrouska <casaxa@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 04:44:30 +0800
Message-Id: <1184705070.8642.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 16:13 +0200, Sasa Ostrouska wrote:
> Hi ,
> 
> I want to ask one question about a custom resolution in the console.
> I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> ugly as I get a border of about 2-3cm on one the sides of the screen.
> So is there a way that I set the 1280x800 resolution at boot time ?

1280x800 is not a VESA standard, so you have to find out the vendor mode
ID for it.  You can use vbetest to list all modes supported by your
card. Or if you don't have vbetest, use X plus the 'vesa' driver and
look at /var/log/X*.log.

Choose the mode ID number you want, add 0x200 and use that.

Tony


