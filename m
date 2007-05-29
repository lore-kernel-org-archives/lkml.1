Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXE2NeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXE2NeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXE2NeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:34:01 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:58375 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXE2NeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:34:00 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <292C7F80-B80D-4645-8FF5-49BF911398E1@cam.ac.uk> <a781481a0705290341w4c403c1ej43565a1e66805522@mail.gmail.com> <37DB6EAF-8954-448D-BD29-864FEC6540CE@cam.ac.uk> <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
Cc: Nitin Gupta <nitingupta910@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm-cc@laptop.org, linuxcompressed-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Richard Purdie <richard@openedhand.com>, Bret Towe <magnade@gmail.com>,
       dwmw2@infradead.org
Content-Transfer-Encoding: 7bit
From: Michael-Luke Jones <mlj28@cam.ac.uk>
Subject: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Tue, 29 May 2007 14:33:51 +0100
To: Satyam Sharma <satyam.sharma@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2007, at 12:27, Satyam Sharma wrote:

> Right, actually, zlib could be switched over to [using a common  
> directory].
> Because zlib_deflate/ and zlib_inflate/ too share a private header
> zutil.h which has unfortunately been stuck into include/linux/ with  
> a big
> /* WARNING: this file should *not* be used by applications. */  
> comment ...

Well, unfortunately zutil.h is currently being used in-kernel by fs/ 
jffs2/compr_zlib.c despite the "WARNING: this file should *not* be  
used by applications" notice.

So moving this header to a truly private location isn't possible  
right now, unfortunately,

Michael-Luke Jones
[added David Whitehouse to cc]
