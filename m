Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708Ab0AET7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0AET7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436Ab0AET7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:59:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0AET7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:59:32 -0500
Message-ID: <4B439A18.3030408@zytor.com>
Date: Tue, 05 Jan 2010 11:59:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2-git6 -- Boot fails with "Destination address too large."
 	with recent kernels when compressed with bz2 or lzma (gzip works).
References: <a44ae5cd1001051155s7204a182wefafbfc2bb2409e4@mail.gmail.com>
In-Reply-To: <a44ae5cd1001051155s7204a182wefafbfc2bb2409e4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 11:55 AM, Miles Lane wrote:
> Hello,
> 
> I can get a gzipped kernel to boot (I am running Ubuntu in a WUBI
> FUSE-mounted EXT3 file system that is stored in a 16GB file on my
> Windows NTFS partition).  But, when I try to compress the kernel with
> lzma or bz2, the boot fails with "Destination address too large."
> 

Known bug (it happens when your sh isn't bash on the compile host, and
possibly some other tools).  It's being addressed.

	-hpa
