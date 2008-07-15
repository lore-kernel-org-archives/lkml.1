Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYGORSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYGORSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYGORSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:18:04 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:10368 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYGORSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:18:03 -0400
Date: Tue, 15 Jul 2008 19:17:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] chsc headers userspace cleanup
Message-ID: <20080715191748.1f3905ad@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080715125817.GB24533@cs181140183.pp.htv.fi>
References: <20080715125817.GB24533@cs181140183.pp.htv.fi>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 15:58:18 +0300,
Adrian Bunk <bunk@kernel.org> wrote:

> Kernel headers shouldn't expose functions to userspace.

Could you please elaborate? Especially as I see e.g.
include/linux/virtio_ring.h exporting functions outside #ifdef
__KERNEL__ as well...
