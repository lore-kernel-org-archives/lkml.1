Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbYF3Gvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbYF3Gvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbYF3GvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:51:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:29936 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100AbYF3GvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EGiL4Qq2KO/rnZzMs3usX5+XmfFxbhuyXZHbcN8Qs8ATD9ACbG+doNaaEjZ4EP2Y8d
         9cZ/15Rm8Fm4tRDtMi2XsoRbboQE8TYqR2vsLVwbN8EGA/qoLoR4N8aKCOStuKBwE/9N
         qnvcRvN05XJL5LPUkhMXmpnTyqdZUtn768a18=
Message-ID: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
Date: Mon, 30 Jun 2008 09:51:16 +0300
From: "Erez Zilber" <erezzi.list@gmail.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Should a block device enforce block atomicity?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question about block devices and whether they are required to
enforce block atomicity:

I read the code of drivers/block/brd.c, and I didn't see any locking
when blocks are read/written. I also looked at the block layer code
that calls brd and didn't find any locking there. Does it mean that
there's no block atomicity (i.e. multiple threads can write a single
block at the same time)? Is there any hidden assumption here? Is this
the responsibility of the application to do that (e.g. not start a
WRITE request before other READ/WRITE requests to the same block were
completed)?

Thanks,
Erez
