Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbXIRIoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbXIRIoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXIRIoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:44:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8444 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbXIRIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=unJPWVVPrc0Yu8xZffH+HjkfqXMJBfZKg4LLdysazypLCm2N741PShzINOcvYTou74nUeCJZC1yBguAnlZQNa284bn+UMA97/JL7vbIp5xGZOBkO4QbLZAzq0t/0N9IZMFPUujEYafldAt+Y+YvDwiItBlnRdAVw04uPli55NnU=
Subject: Re: VGA text console display problem with kernel 2.6.23-rc5/6
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: lnx-kern@soo.com
Cc: Kernel Mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <46EF7DAD.3080502@soo.com>
References: <46EF7DAD.3080502@soo.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 16:44:15 +0800
Message-Id: <1190105055.6446.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 03:26 -0400, ben soo wrote:
> i've 2 servers with old PCI VGA cards, one using X86_64 kernel 
> version 2.6.23-rc5 and one with i386 kernel version 2.6.23-rc6,
> both wired into the same CRT via a KVM switch.

Is this new? If yes, what's the version of the last working kernel?

> 
> No matter what text screen size i set on both these machines (using 
> resizecons) the shell line where i type in commands is past the 
> bottom of the screen, invisible.
> 
> Another box connected to the same KVM displays fine, and it runs 
> 2.6.22-rc7.
> 
> i also have a box running kernel 2.6.23-rc5 where the console 
> display is fine: it uses a GeForce 8500 PCI-E vidcard driving a LCD 
> screen.

Can you post dmesg and output of stty -a?

Tony


