Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXEFVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXEFVDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXEFVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:03:24 -0400
Received: from lazybastard.de ([212.112.238.170]:54415 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbXEFVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:03:23 -0400
Date: Sun, 6 May 2007 22:59:02 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070506205901.GA11665@lazybastard.org>
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk> <20070504094610.GA31607@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070504094610.GA31607@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 10:46:10 +0100, Christoph Hellwig wrote:
> 
> Which means the right place to fix this is samba.  Samba just need
> to intersept lseek and pread/pwrite to never allocate sparse files
> but do the right thing instead.  Now what the right thing would probably
> be a preallocate instead of writing zeroes, and we need to provide the
> infrastructure for them to do it, which is in progress currently.

Why do preallocate and not just truncate the file?  If the write is a
single 0x00 somewhere beyond EOF, as appears to be the pattern, truncate
will do just as well if not better.  And it is available now.

Jörn

-- 
Joern's library part 6:
http://www.gzip.org/zlib/feldspar.html
