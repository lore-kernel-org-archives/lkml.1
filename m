Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbYBNMJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbYBNMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYBNMJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:09:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41681 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756963AbYBNMJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:09:46 -0500
Date: Thu, 14 Feb 2008 12:02:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 11/11] ata: fix sparse warnings in pata_legacy.c
Message-ID: <20080214120206.1a52f77d@core>
In-Reply-To: <1202966072.2748.27.camel@brick>
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com>
	<1202966072.2748.27.camel@brick>
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

On Wed, 13 Feb 2008 21:14:32 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Let's use ld for legacy_data instead of shadowing these static
> int variables.

NAK - I purposefully used names that indicate what device the private
data is being used for in order to make it clear. Changing qdi and
winbond to ld_qdi and ld_winbond would avoid that and fix the shadowing
of the static value.

Alan
