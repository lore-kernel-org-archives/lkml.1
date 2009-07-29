Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZG2Oeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZG2Oeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZG2Oeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:34:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:56742 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZG2Oef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:34:35 -0400
Date: Wed, 29 Jul 2009 07:36:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Aaron Gray" <aaronngray.lists@googlemail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Does Linux support Data Exectiion Protection ?
Message-ID: <20090729073645.13f72a33@infradead.org>
In-Reply-To: <864C1A9245EB4A3581996E6477890451@HPLAPTOP>
References: <864C1A9245EB4A3581996E6477890451@HPLAPTOP>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 15:08:35 +0100
"Aaron Gray" <aaronngray.lists@googlemail.com> wrote:

> Does Linux suppoert DEP, on newer x86 CPU's ?

it does and has been for the better part of at least 5 years.

 
> I am wondering as this does effect alot of VM's using JIT technology
> if they are wriiten without proper code memory allocation. 

given how old our support is, all JITs seem to be working.
In addition there is a compatibility provision for legacy binaries
implemented.

>  This is a
> problem for StrongTalk and FoNC' IDC. If EP is availiable how
> configurable is it ?

just make sure you use 64 bit pagetables (either a 64 bit kernel or a
32 bit kernel with PAE support) and you get the support.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
