Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZBRQOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZBRQOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBRQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:14:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50920 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752815AbZBRQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:14:41 -0500
Date: Wed, 18 Feb 2009 16:45:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [RESEND] binfmt_script: rewrite using
 parse_shell_args()
Message-ID: <20090218164546.7d2b312a@the-village.bc.nu>
In-Reply-To: <20090218152956.GA15633@srcf.ucam.org>
References: <1234970162-10694-1-git-send-email-kirill@shutemov.name>
	<1234970162-10694-2-git-send-email-kirill@shutemov.name>
	<20090218151616.GC15195@srcf.ucam.org>
	<20090218152252.GB5270@epbyminw8406h.minsk.epam.com>
	<20090218152956.GA15633@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > As mentioned before, this breaks userspace ABI.
> > 
> > Do you have real world example of breakage?
> 
> Have you checked every script on every Linux system?

And even if he did its an ABI and an important one. It is fixed and
defined. If you want a non standard behaviour please implement it via
binfmt_misc and a helper.
