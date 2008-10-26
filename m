Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYJZLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYJZLCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYJZLCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:02:43 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:45964 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJZLCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:02:42 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: WARNING: at drivers/ata/libata-eh.c:664 (and others) with 2.6.27-05178
Date: Sun, 26 Oct 2008 12:02:37 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200810251118.14714.borntraeger@de.ibm.com>
In-Reply-To: <200810251118.14714.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261202.37202.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 25. Oktober 2008 schrieb Christian Borntraeger:
> Hello Jens,
> 
> while doing a backup on DVD+R I got the following warning (and a k3b hung).
> the drive is a Plextor 716A on a jmicron PATA port.
> I have never seen this with earlier kernels. I am a bit reluctant to
> reproduce or bisect this problem, since it might kills my blank DVDs.
> Could this be related to commit
> e013e13bf605b9e6b702adffbe2853cfc60e7806 (libata: fix bug with non-ncq 
devices)?
> Thank you for any idea.

OK. Now it also fails on 2.6.26, so it looks like a hardware problem.
The only difference is, that 2.6.26 shows no WARN_ON.

Christian
