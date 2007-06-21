Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbXFUXwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbXFUXwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXFUXvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:51:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37540 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbXFUXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:51:46 -0400
Subject: Re: Linux Kernel include files
From: Arjan van de Ven <arjan@infradead.org>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
In-Reply-To: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 21 Jun 2007 16:47:58 -0700
Message-Id: <1182469678.2704.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Cdrtools ftp://ftp.berlios.de/pub/cdrecord/alpha/ offer support for an OS 
> dependent SCSI transport. Cdrtools cannot be compiled wihout support for SCSI 
> transport, so it is impossible to use Sun Studio to compile cdrtools.
> 
> Why does this happen?
> 
> Well, the reason is that in order to support Linux specific features, you need 
> to include Linux specific include files (the Linux kernel include files).


I assume you typoed and meant "cleaned up kernel include files as
installed by make headers_install" instead.

>  As 
> these include files are currently not written in vanilla (ANSI) C but in a 
> GCC-C-variant, other compilers do not like these include files.

can you give a specific example of a header installed by make
headers_install that breaks this way and is hurting you? Because it may
well be possible to fix the problems, now that we have this special
cleanup phase since several releases....


