Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYCAM0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYCAM0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYCAM0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:26:42 -0500
Received: from mx09.lb01.inode.at ([62.99.145.9]:63262 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024AbYCAM0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:26:41 -0500
X-Greylist: delayed 52189 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 07:26:41 EST
From: Gerold Jury <gml@inode.at>
To: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: extra bytes written to SATA DVD drive on kernel 2.6.23 till 2.6.24.2
Date: Sat, 1 Mar 2008 13:29:11 +0100
User-Agent: KMail/1.9.7
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <200802252005.22663.gml@inode.at> <200802292259.12047.gml@inode.at> <20080301145354.ca4d4f1a.vsu@altlinux.ru>
In-Reply-To: <20080301145354.ca4d4f1a.vsu@altlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011329.11315.gml@inode.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes it happens with the DVD+RW (testet with dd now) and with DVD+R

Thank you for the byte interpretation.
Now I have a hint where to start with the debugging.

Regards
Gerold

On Saturday 01 March 2008 12:53:54 Sergey Vlasov wrote:
>
>0x2a is the SCSI WRITE(10) command; the following 10 bytes look like
>its arguments (bytes 2-5 - logical block address, bytes 7-8 - transfer
>length in blocks); last 4 bytes seem to be another copy of the logical
>block address.
>
>
>Does this happen only with DVD-RAM?  Could you try with a DVD+RW disk
>(these disks could also be written to with a simple "dd" after initial
>formatting)?
>
