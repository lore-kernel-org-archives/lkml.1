Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYG3Koy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYG3Koy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYG3Kor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:44:47 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47885 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYG3Koq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:44:46 -0400
Date: Wed, 30 Jul 2008 12:44:45 +0200
To: Ryan Hope <rmh3093@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel bug (null pointer) in 2.6.27-rc1
Message-ID: <20080730104445.GV30902@gamma.logic.tuwien.ac.at>
References: <20080729215456.GE30307@gamma.logic.tuwien.ac.at> <48f7fe350807291547g2d67eabcka5dc63c9c0e62239@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350807291547g2d67eabcka5dc63c9c0e62239@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 29 Jul 2008, Ryan Hope wrote:
> This patch fixes this issue, it fixed it for me:

Thanks, although that ...

> -static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
> -		   sched_smt_power_savings_store);
> +static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
> +                    sched_smt_power_savings_show,
>  #endif

Seems to be bogus and produced a
	kernel/sched.c:9137:1: error: unterminated argument list
	invoking macro "SYSDEV_CLASS_ATTR"
Hopefully not in the kernel ...

Rebooting soon ...

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TILLICOULTRY (n.)
The man-to-man chumminess adopted by an employer as a prelude for
telling an employee that he's going to have to let him go.
			--- Douglas Adams, The Meaning of Liff
