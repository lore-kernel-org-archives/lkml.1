Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbYBNSEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbYBNSEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYBNSDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:03:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33057 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbYBNSDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:03:53 -0500
Date: Thu, 14 Feb 2008 17:56:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 11/11v2] ata: fix sparse warnings in pata_legacy.c
Message-ID: <20080214175608.0a361b13@core>
In-Reply-To: <1203010593.2748.43.camel@brick>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	<1202966072.2748.27.camel@brick>
	<20080214120206.1a52f77d@core>
	<1203010593.2748.43.camel@brick>
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

On Thu, 14 Feb 2008 09:36:32 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Use ld_qdi and ld_winbond to avoid shadowing static int
> variables qdi and winbond.  The ld_ prefix refers to
> legacy_data.
> 
> drivers/ata/pata_legacy.c:777:21: warning: symbol 'qdi' shadows an earlier one
> drivers/ata/pata_legacy.c:128:12: originally declared here
> drivers/ata/pata_legacy.c:811:21: warning: symbol 'qdi' shadows an earlier one
> drivers/ata/pata_legacy.c:128:12: originally declared here
> drivers/ata/pata_legacy.c:848:21: warning: symbol 'qdi' shadows an earlier one
> drivers/ata/pata_legacy.c:128:12: originally declared here
> drivers/ata/pata_legacy.c:882:21: warning: symbol 'qdi' shadows an earlier one
> drivers/ata/pata_legacy.c:128:12: originally declared here
> drivers/ata/pata_legacy.c:1040:21: warning: symbol 'winbond' shadows an earlier one
> drivers/ata/pata_legacy.c:129:12: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>
