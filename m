Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZETKjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZETKjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZETKjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:39:03 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:52895 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZETKjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:39:02 -0400
From: Christian =?iso-8859-1?q?Borntr=E4ger?= <borntrae@de.ibm.com>
Organization: IBM
To: =?iso-8859-1?q?Andr=E9_Lopes?= <andre.neo.net@gmail.com>
Subject: Re: Are the cast necessary in function "kfree"?
Date: Wed, 20 May 2009 12:38:15 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-self-00043-g22ef37e; KDE/4.2.2; i686; ; )
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5c43c2d40905200330p5b14be2ey567bc493374e09b3@mail.gmail.com>
In-Reply-To: <5c43c2d40905200330p5b14be2ey567bc493374e09b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905201238.16160.borntrae@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 20 Mai 2009 12:30:21 schrieb André Lopes:

I only looked at the s390 parts:

> arch/s390/include/asm/idals.h:110: kfree((void *)(unsigned long) ccw->cda);
This cast is necessary since cda is an u32 even on 64bit machines.

> drivers/s390/char/vmur.c:188:        kfree((void *)(addr_t) ptr->cda);
dito.

Christian


