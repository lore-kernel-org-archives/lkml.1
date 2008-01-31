Return-Path: <linux-kernel-owner+w=401wt.eu-S1765784AbYAaItx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765784AbYAaItx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbYAaItm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:49:42 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:9551 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753033AbYAaItm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:49:42 -0500
Date: Thu, 31 Jan 2008 17:48:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Kbuild] How to clean a particular directory ?
Message-ID: <20080131084851.GB14160@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Francis Moreau <francis.moro@gmail.com>,
	linux-kernel@vger.kernel.org
References: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 09:38:10AM +0100, Francis Moreau wrote:
> I'd like to clean a particular directory in the kernel tree.
> 
> I tried several things such as:
> 
> $ make drivers/char clean
> $ make -f scripts/Makefile.clean obj=drivers/char
> 
> But it doesn't work.
> 
> Could anybody give me  a hint ?

make SUBDIRS=drivers/char clean

should do the trick. Kbuild might have a magic incantation for it these
days, but that's the way it used to work, and still seems to.
