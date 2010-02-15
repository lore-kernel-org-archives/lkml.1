Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0BOQLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:11:20 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40628 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0BOQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:11:19 -0500
Date: Mon, 15 Feb 2010 11:11:11 -0500
From: Jeff Dike <jdike@addtoit.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML broken - runaway loop modprobe binfmt-464c
Message-ID: <20100215161111.GA18664@c2.user-mode-linux.org>
References: <4B78EE15.9020407@shikadi.net> <20100215113730.GL12076@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100215113730.GL12076@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:37:30PM +0800, Américo Wang wrote:
> So you are using 32-bit modprobe binary and 64-bit kernel?
> 
> This will not work, since kernel binfmt_elf module checks
> if e_machine is EM_X86_64.

Not just 32-bit modprobe - any 32-bit binary on a 64-bit UML will
cause this, I think.

				Jeff
