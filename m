Return-Path: <linux-kernel-owner+w=401wt.eu-S1751607AbXJUDEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbXJUDEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 23:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXJUDED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 23:04:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:51713 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750831AbXJUDEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 23:04:01 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+O509PlWCO/44w+wiYRNmCvGubQQzIIuWfF0eeBk
	5ueGpBIqNLQqGS
From: Helge Deller <deller@gmx.de>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Time-based RFC 4122 UUID generator
Date: Sat, 20 Oct 2007 21:39:25 +0200
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
Cc: Valdis.Kletnieks@vt.edu
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710202139.25595.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

this is a series of two patches for the kernels UUID generator which was already posted two weeks ago to LKML for discussion: 
http://lkml.org/lkml/2007/10/6/37

1) The first patch fixes a real (although not too critical) bug in the current UUID random generator. It would be great if this could go to Linus soon.

2) The second patch implements a time-based UUID generator acording to RFC 4122. It would be great if you could apply this patch to your mm tree for broader testing.

I did tested the patches sucessfully on x86-32 and hppa (big-endian).

Helge
