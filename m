Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXCFQfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXCFQfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965294AbXCFQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:35:38 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:51831 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965292AbXCFQfh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:35:37 -0500
X-Greylist: delayed 6179 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2007 11:35:37 EST
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: return negative number for unsigned long function in kernel
Date: Tue, 6 Mar 2007 09:52:34 -0500
Message-ID: <314BE1148B8C8D468A05944FDF577583069B021E@MRE02.enterprise.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: return negative number for unsigned long function in kernel
Thread-Index: Acdf/xO0ZtB2sG02Rz25I+qq9fD3lQ==
From: "Chen, Dongliang" <Chen.D@ems-t.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Chen, Dongliang" <Chen.D@ems-t.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of functions in the Linux kernel that are declared as
unsigned long, but the return value is negative integer while error
occurred. An example of these functions is do_mmap_pgoff in mm/mmap.c,
which is defined as:

unsigned long do_mmap_pgoff(....)

In this function, it returns -ENODEV, -EPERM, -ENOMEM, -EINVAL, -EAGAIN,
-EACCESS depends on the error type. My question is how should the caller
perform error check based on the return value? 


Please CC reply to me at chen.d@ems-t.com
 

Thanks,

Dongliang Chen

Staff Engineer
EMS Technologies, Inc - Defense and Space Systems
660 Engineering Dr
Norcross, GA 30092
Tel: 770-263-9200 x 4379



