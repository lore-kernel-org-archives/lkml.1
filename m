Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbXGWOne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbXGWOne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXGWOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:43:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:39854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXGWOnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,570,1175497200"; 
   d="scan'208";a="269444705"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: where is the code for read system call?
Date: Mon, 23 Jul 2007 07:43:23 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858D1FD@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707210208.44698.fzu@wemgehoertderstaat.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: where is the code for read system call?
thread-index: AcfLNoAXuyqN4Y0rSr2WG58ZcUyZegCATeYw
References: <A3258B497F1C1441AD36A2E8B45FD62858CFA6@scsmsx412.amr.corp.intel.com> <200707210208.44698.fzu@wemgehoertderstaat.de>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Karsten Wiese" <fzu@wemgehoertderstaat.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Jul 2007 14:43:25.0011 (UTC) FILETIME=[D2FE1230:01C7CD37]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For future how do I trace a system call to a function in a kernel?

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Karsten Wiese
Sent: Friday, July 20, 2007 5:09 PM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: where is the code for read system call?

Am Samstag, 21. Juli 2007 schrieb Agarwal, Lomesh:
> My application reads from socket. I need to change the behavior of
read
> system call for an experiment. Can someone point me to code?

fs/read_write.c: line 356
asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t
count)
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
