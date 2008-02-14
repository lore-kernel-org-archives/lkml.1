Return-Path: <linux-kernel-owner+w=401wt.eu-S1765620AbYBNMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765620AbYBNMI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYBNMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:08:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41677 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754556AbYBNMIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:08:46 -0500
Date: Thu, 14 Feb 2008 12:01:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 05/11] ata: replace macro with static inline in libata.h
Message-ID: <20080214120101.150a3284@core>
In-Reply-To: <1202966058.2748.19.camel@brick>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	<1202966058.2748.19.camel@brick>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 21:14:18 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Avoid a metric ton of sparse warnings like:
> drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
> drivers/ata/pata_ali.c:176:14: originally declared here

NAK that appears to be a sparse bug.

1-4/6-10 Acked-by: Alan Cox <alan@redhat.com>

Alan
