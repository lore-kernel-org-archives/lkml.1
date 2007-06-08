Return-Path: <linux-kernel-owner+w=401wt.eu-S1030550AbXFHQgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030550AbXFHQgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969333AbXFHQgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:36:01 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:44120 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969246AbXFHQgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:36:01 -0400
Subject: Re: JIT emulator needs
From: Nicholas Miell <nmiell@comcast.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Albert Cahalan <acahalan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070608121059.4efcd338@the-village.bc.nu>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070608121059.4efcd338@the-village.bc.nu>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 09:35:59 -0700
Message-Id: <1181320559.2794.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:10 +0100, Alan Cox wrote:
> > e. mremap() flag to get a read/write mapping of a read/exec one
> > f. mremap() flag to get a read/exec mapping of a read/write one
> > g. mremap() flag to make the 5th arg (new addr) be the upper limit
> 
> This is all mprotect and munmap.

I think he's asking for a way to copy an existing mapping, which does
sound genuinely useful. (i.e. mremap(ptr, size, size, MREMAP_COPY), with
no need to mess with files to get multiple mappings of the same region)

-- 
Nicholas Miell <nmiell@comcast.net>

