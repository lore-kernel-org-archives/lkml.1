Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXCXQOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXCXQOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXCXQOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:14:31 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:33792 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbXCXQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:14:31 -0400
Date: Sat, 24 Mar 2007 17:14:27 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error in compilation kernel 2.6.19 - internal compiler error
Message-ID: <20070324171427.09748529@localhost>
In-Reply-To: <460547AA.80309@wanadoo.fr>
References: <460547AA.80309@wanadoo.fr>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 16:45:46 +0100
Thibaud Hulin <hulin.thibaud@wanadoo.fr> wrote:

> I'm triyng to compile the kernel 2.6.19 on Debian Testing 4.0
> Unfortunately, I can't success.
> This is my error message :
> 
> CC [M]  drivers/scsi/lpfc/lpfc_sli.o
> In file included from drivers/scsi/lpfc/lpfc_sli.c:23:
> include/linux/pci.h:251: internal compiler error: in build_int_cst_wide, 
> at tree.c:803
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://gcc.gnu.org/bugs.html> for instructions.
> For Debian GNU/Linux specific bug reporting instructions,
> see <URL:file:///usr/share/doc/gcc-4.1/README.Bugs>.
> The bug is not reproducible, so it is likely a hardware or OS problem.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Have you read the error message?

It could be a memory problem (defective module)... try run memtest86 or
memtest86+ (http://www.memtest.org/) for many hours (>= 8, someone
suggest even 24h, just to be sure :).

If the problem is big memtest should find it soon.

-- 
	Paolo Ornati
	Linux 2.6.20.4 on x86_64
