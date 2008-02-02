Return-Path: <linux-kernel-owner+w=401wt.eu-S935164AbYBBUmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164AbYBBUmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935039AbYBBUmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:42:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37390 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935027AbYBBUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:42:29 -0500
Date: Sat, 2 Feb 2008 21:42:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Some fixes for "Section mismatch" errors.
Message-ID: <20080202204233.GB26415@uranus.ravnborg.org>
References: <804dabb00802020800m61a6f87apb154cacc22275ef8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802020800m61a6f87apb154cacc22275ef8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 12:00:29AM +0800, Peter Teoh wrote:
> Today, I pulled from linus tree, and compile with MANY section
> mismatches errors, eg, some of which are like the following:
> 
> WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x1c9f): Section mismatch
> in reference from the function hdsp_check_for_firmware() to the
> function .devinit.text:hdsp_request_fw_loader()
> WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x35bf): Section mismatch
> in reference from the function snd_hdsp_proc_read() to the function
> .devinit.text:hdsp_request_fw_loader()

Your fix for this particular warning looks OK.
But always do:
-> One fix per patch
-> Include the warning in the patch descript that you fix
-> Explain why you fixed it the way you did it

Without this info it is too time consuming to try to review your patch
and I did nt look at the other changes you included.

	Sam
