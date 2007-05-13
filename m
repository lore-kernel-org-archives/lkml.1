Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXEMTBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXEMTBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 15:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXEMTA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 15:00:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475AbXEMTA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 15:00:56 -0400
Message-ID: <46476049.2090806@redhat.com>
Date: Sun, 13 May 2007 15:00:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Rodrigo Amestica <ramestic@nrao.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: is linux still a none swappable kernel?
References: <464746EC.10608@nrao.edu>
In-Reply-To: <464746EC.10608@nrao.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodrigo Amestica wrote:
> In some older posts I have read that memory allocations via kmalloc
> and vmalloc are not swappable, that is, these memory chunks are not
> paged out to swap area. Is this still the case with linux kernel 2.6?

Yes.

Unswappable kernel memory is simpler and faster.

Over the last 15 years, the memory requirements of the
Linux kernel have grown maybe a factor 10, while the
memory of computers has grown by a factor of 1000.

The data structures that grow with memory (mostly the
mem_map[] array of page structs) has actually gotten
smaller since the 2.4 kernel and now takes under 1%
of memory even on x86-64.

There really is no good reason for swapping kernel
memory nowadays.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
