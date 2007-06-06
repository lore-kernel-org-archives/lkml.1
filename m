Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbXFFPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbXFFPSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbXFFPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:18:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:59637 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923AbXFFPSe (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:18:34 -0400
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
From: Richard Griffiths <richard.griffiths@windriver.com>
Reply-To: richard.griffiths@windriver.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Linux-kernel@vger.kernel.org
In-Reply-To: <20070606113351.GA11701@infradead.org>
References: <1179871779.24163.11.camel@localhost.localdomain>
	 <20070522154905.1d7e8a2e.akpm@linux-foundation.org>
	 <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
	 <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux Products Group
Date: Wed, 06 Jun 2007 08:17:43 -0700
Message-Id: <1181143064.4194.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 06 Jun 2007 15:17:44.0398 (UTC) FILETIME=[D51156E0:01C7A84D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 12:33 +0100, Christoph Hellwig wrote:
> I might be a little late in the discussion, but I somehow missed this
> before.  Please don't add this xip support to cramfs, because the
> whole point of cramfs is to be a simple _compressed_ filesystem,
> and we really don't want to add more complexity to it.  Please
> use something like the existing ext2 xip mode instead of add support
> to romfs using the generic filemap methods.
Too late :) The XIP cramfs patch is widely used in the embedded Linux
community and has been used for years. It fulfills a need for a small
XIP Flash file system. Hence our interest in getting it or some
variation into the mainline kernel.


