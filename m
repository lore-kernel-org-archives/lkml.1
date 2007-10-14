Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbXJNFSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbXJNFSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXJNFSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:18:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:13923 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXJNFSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b61Fd+nmHPOmMK2vmWxq1iEv4452edc7C7f9/uOyb34F/xVuBarvkx1yOu20QAMh6dli+PcGJPyqHdoaWLs0gwp2v7c0KB4Ve8I/USqxFiGKfCxSPbtKMyB8N3QVFd/JfSpzPhdZcMv9x+NAOVCdiNHZ49VOj30PlfELd3IcJYI=
Subject: Re: 2.6.23: No text consoles with
	FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710132013.24024.elendil@planet.nl>
References: <200710132013.24024.elendil@planet.nl>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 13:18:29 +0800
Message-Id: <1192339109.6548.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 20:13 +0200, Frans Pop wrote:
> While running a test with current Linus' git tree, I ran into the following
> issue. The issue is also present in stable 2.6.23.
> 
> System x86_64; Pentium D; Intel 82945G/GZ on-board graphics
> 
> After initial boot messages all output to console stops. The last visible
> messages are:
> checking if image is initramfs...<6>Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> 
> After that, nothing until XOrg starts up and graphical login/desktop on VT7
> are displayed normal.
> Switching back to VT1-VT5 gives nothing: no login prompts, just nothing.
> 

Can you also post your dmesg and /proc/cdmline?

Tony


