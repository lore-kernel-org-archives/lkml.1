Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXISVvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXISVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXISVuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:50:55 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:41105 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751148AbXISVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:50:55 -0400
Message-ID: <46F199CC.4080600@cfl.rr.com>
Date: Wed, 19 Sep 2007 17:51:08 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: iso9660 vs udf
References: <20070915214926.GA31416@mette>
In-Reply-To: <20070915214926.GA31416@mette>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 21:51:09.0614 (UTC) FILETIME=[303F34E0:01C7FB07]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15434.001
X-TM-AS-Result: No--11.184900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andries E. Brouwer wrote:
> Today I got a CD. MacOS does not mount it and Linux does not
> mount it without an explicit filesystemtype option.
> That is,
> 	# mount /dev/hdc /dir -t iso9660
> works fine, but
> 	# mount /dev/hdc /dir
> 	mount: you didn't specify a filesystem type for /dev/hdc
>                I will try type udf
>         mount: wrong fs type, bad option, bad superblock on /dev/hdc,
>                missing codepage or other error
>                In some cases useful info is found in syslog - try
>                dmesg | tail  or so
> 	# dmesg | tail
>         UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'Wisk1956-82', timestamp 2006/03/07 16:26 (1078)
>         udf: udf_read_inode(ino 547) failed !bh
>         UDF-fs: Error in udf_iget, block=1, partition=1

What does the line for hdc show in /etc/fstab?  Mount tries whichever 
filesystem(s) is/are listed there if you omit -t.  My guess is that it 
only lists udf and this is a cd so it contains iso9660, not udf.

