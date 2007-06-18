Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbXFRBJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbXFRBJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXFRBJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:09:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37561 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXFRBJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:09:31 -0400
Subject: Re: AT_ENTROPY1 and AT_ENTROPY2 values for include/linux/auxvec.h
From: Arjan van de Ven <arjan@infradead.org>
To: Alexander Gabert <pappy@gentoo.org>
Cc: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
       hardened@gentoo.org
In-Reply-To: <4675C678.3080807@gentoo.org>
References: <4675C678.3080807@gentoo.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 17 Jun 2007 18:06:43 -0700
Message-Id: <1182128803.22999.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 01:40 +0200, Alexander Gabert wrote:
> Hello glibc and kernel maintainers,
> 
> could you please add two AT_ entries to include/linux/auxvec.h in the 
> upstream kernel and the respective elf/elf.h definitions in glibc.


while I'm not per se against adding such aux vectors, I think it's a bad
mistake to make them a config option (and 2 options at that!!)

Stack protector is very widely deployed today
(Fedora,RHEL,SLES,OpenSUSE,Gentoo etc), so I can sure see the point of
helping it a bit... but I'd like to see a little more data on how the
current approach isn't sufficient.


