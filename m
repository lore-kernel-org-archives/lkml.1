Return-Path: <linux-kernel-owner+w=401wt.eu-S965004AbXAWNMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004AbXAWNMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXAWNMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:12:35 -0500
Received: from ppsw-2.csi.cam.ac.uk ([131.111.8.132]:49493 "EHLO
	ppsw-2.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004AbXAWNMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:12:34 -0500
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: Could convert a buffer that allocated by vmalloc to pages?
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Yu-Chen Wu <g944370@oz.nthu.edu.tw>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky>
References: <030701c73eef$0b4d0010$0100a8c0@sslabmayasky>
Content-Type: text/plain
Organization: Computing Service, University of Cambridge, UK
Date: Tue, 23 Jan 2007 13:12:24 +0000
Message-Id: <1169557944.4475.8.camel@imp.csi.cam.ac.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-23 at 21:04 +0800, Yu-Chen Wu wrote:
> Hi,
> I write a driver have a big buffer (16MB,allocated by vmalloc).
> I want to use the buffer to do DMA transmission so I need getting the pages
> of the buffer.
> Have any kernel API can do this?
> My platform is x86_64 and 2GB RAM

vmalloc_to_page()...

See mm/memory.c for the function and how to use it.

Best regards,

        Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

