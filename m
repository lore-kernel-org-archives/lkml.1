Return-Path: <linux-kernel-owner+w=401wt.eu-S968730AbXEIGC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968730AbXEIGC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXEIGCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:02:51 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:47184 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbXEIGCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mk2Cqwx6E8AQRZV/KgYOwq6G3SUyNFiXQr/mBjvykv9Bef0molvcZYEJ47DDlFb6rgoRJDuT6vDi3AeKqA4wiLZyWjQ3hCwmxXTemln8Aq+JaukHlSCGJ8UFubDGkGRDSnVRewsZ95l9V0BnVY2Mf+d3zIbN6HF1joHzopGqxrI=
Subject: Re: Please revert 464bdd33e9baad9806c7adbd8dfc37081a55f27e
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46413A7E.5050304@garzik.org>
References: <46413851.6070505@zytor.com>  <46413A7E.5050304@garzik.org>
Content-Type: text/plain
Date: Wed, 09 May 2007 14:02:24 +0800
Message-Id: <1178690544.4747.20.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 23:05 -0400, Jeff Garzik wrote:
> H. Peter Anvin wrote:
> > Checkin 464bdd33e9baad9806c7adbd8dfc37081a55f27e "fbdev: ignore VESA
> > modes if framebuffer is disabled" is just plain wrong on any system
> > which has support for extended text modes in its VESA BIOS.
> > 
> > Antonio is incorrectly assuming this branchout is used only to set VESA
> > graphics modes, but it's to set any VESA mode, be it text or graphics.
> 
> I wonder if this fbdev update is what causes my X session to die?

That's doubtful though, CONFIG_FB=n. For a start, you can try reverting
changes in drivers/char/vt.c and drivers/video/console/vgacon.c

Tony


