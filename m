Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYGCN5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYGCN5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYGCN5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:57:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:51779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYGCN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:57:41 -0400
Date: Thu, 3 Jul 2008 06:56:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Giacomo A. Catenazzi" <cate@debian.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       "Selbak, Rolla N" <rolla.n.selbak@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New
 World Order firmware...
Message-ID: <20080703065630.2aefc930@infradead.org>
In-Reply-To: <486C9AD2.6020604@debian.org>
References: <4534.1215048758@turing-police.cc.vt.edu>
	<Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet>
	<32146.1215066947@turing-police.cc.vt.edu>
	<Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
	<486C9AD2.6020604@debian.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2008 11:24:34 +0200
"Giacomo A. Catenazzi" <cate@debian.org> wrote:

> There are two format of Intel CPU microcode and two methods to load
> it.
> - old: the microcodes are in a big file, which include multiple
>    microcodes (for multiple CPU).  The driver require a char device
>    and a user space loader ("microcode_ctl")
> - new: one microcode per file, using the 'request_firmware'
>    infrastructure. No user space support needed.
> 
> Actually Intel provides only the old methods.
> There was talks with Arjan and Intel about the distribution format
> for the new methods. But I don't have any new.
> I think that when the new format is fully specified (directory
> structure, tar, gzip,...) Intel will distribute the microcodes
> in the new form.


we hope to switch to the new form but there's the small case of
"installed base" using ancient kernels, and it's kind of not nice to
have to release 2 sets. At some point we will switch over though.
