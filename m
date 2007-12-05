Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbXLEHXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbXLEHXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXLEHXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:23:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45538 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXLEHXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:23:43 -0500
Date: Wed, 5 Dec 2007 08:25:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
Message-ID: <20071205072529.GA5681@uranus.ravnborg.org>
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47555C64.8070607@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun.
On Tue, Dec 04, 2007 at 10:55:48PM +0900, Tejun Heo wrote:
> Kbuild now generates and installs modules.order along with modules.
> This patch updates depmod such that it sorts module list according to
> the file before generating output files.  Modules which aren't on
> modules.order are put after modules which are ordered by
> modules.order.
> 
> This makes modprobe to prioritize modules according to kernel
> Makefile's just as built-in modules are link-ordered by them.

With this change depmod require the precense of modules.order.
Could we make it optional so depmod are backward compatible?

It would also simplify the kbuild integration if depmod
could read the modules as a space separated list where
duplicates are allowed.
If we do so then the is no reason to escape to the shell
in Makeilfe.build and we do not have to remove duplicates either.

	Sam
