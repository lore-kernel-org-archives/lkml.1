Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYDXNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYDXNnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYDXNni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:43:38 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33582 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYDXNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:43:37 -0400
Message-ID: <48108E85.50209@hp.com>
Date: Thu, 24 Apr 2008 09:43:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <48108BC6.5030409@hp.com>
In-Reply-To: <48108BC6.5030409@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:

>
> Kernel                NM  I/Os per second
> --------------------  --  ---------------
> 2.6.25 (not patched)           483,727.36
> 2.6.25 + nomerges      0       483,880.96
> 2.6.25 + nomerges      1       483,921.92

Wrong chart, sorry:

Kernel                NM  I/Os per second
--------------------  --  ---------------
2.6.25 (not patched)               472.39
2.6.25 + nomerges      0           472.54
2.6.25 + nomerges      1           472.58

(Don't think a little 2-way box w/ 4 SATA drives can really approach
500K I/Os per second...)

Alan
