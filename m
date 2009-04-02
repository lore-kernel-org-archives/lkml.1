Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZDBTM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZDBTM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZDBTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:12:05 -0400
Received: from [213.79.90.228] ([213.79.90.228]:2790 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759598AbZDBTMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:12:03 -0400
Date: Thu, 2 Apr 2009 23:11:59 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Timur Tabi <timur@freescale.com>
Cc: Marcel Ziswiler <marcel@ziswiler.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] QE USB Host Integration for MPC832x
Message-ID: <20090402191159.GA14626@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1238622396-9768-1-git-send-email-marcel@ziswiler.com> <20090402183357.GA29050@oksana.dev.rtsoft.ru> <20090402183631.GA6699@oksana.dev.rtsoft.ru> <49D5071D.50001@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <49D5071D.50001@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:42:37PM -0500, Timur Tabi wrote:
> Anton Vorontsov wrote:
> 
> > Oh, I was wrong. fsl_qe_udc driver uses mpc8360 compatible for
> > matching, so you can't remove it. :-/
> 
> Ugh, that's a bug in the driver then.

Yes, but that depends on what chip was the first one? MPC8323 or
MPC8360?

> My understanding is that the only MPC8323 QE microcode update is the one
> for UART.  If there are any updates to any other QE devices for standard
> functionality, I'm not aware of any.

I found them:

http://www.freescale.com/files/netcomm/software/app_software/microcode/QERAMPTCH.zip?fpsp=1

File is qe_usb3-8323_Rev11.c

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
