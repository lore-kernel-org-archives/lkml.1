Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZFKSqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZFKSqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZFKSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:45:38 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:61254 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758360AbZFKSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:45:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.42,203,1243807200";   d="scan'208";a="15104706"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Andi Kleen'" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
In-reply-to: <87zldjn597.fsf@basil.nowhere.org>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Thu, 11 Jun 2009 20:45:29 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSO5HuYG95Ox0vSfOQ9r4UBh4c3gYg8cHA
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your patches seem to have a lot of overlap with
> Lee Schermerhorn's old migrate memory on cpu migration patches.
> I don't know the status of those.

I analyze Lee Schermerhorn's migrate memory on cpu migration patches
(http://free.linux.hp.com/~lts/Patches/PageMigration/). I think that Lee
Schermerhorn add similar functionalities to the kernel. He called the
"affinity-on-next-touch" functionality "migrate_on_fault" and uses in his
patches the normal NUMA memory policies. Therefore, his solution fits better
to the Linux kernel. I tested his patches with our test applications and got
nearly the same performance results. 

I found only patches for the kernel 2.6.25-rc2-mm1. Does someone develop
these patches further?

Stefan



