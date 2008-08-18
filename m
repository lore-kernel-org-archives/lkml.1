Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYHRN47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYHRN47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYHRN4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:56:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbYHRN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:56:50 -0400
Message-ID: <48A97F76.7060201@linux-foundation.org>
Date: Mon, 18 Aug 2008 08:56:06 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-mm@kvack.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for August 11/12 - powerpc - oops at __kmalloc_node_track_caller
 ()
References: <20080812185345.d7496513.sfr@canb.auug.org.au> <48A1C924.6020000@linux.vnet.ibm.com> <48A1D65A.8000600@linux-foundation.org> <48A75E72.7050508@linux.vnet.ibm.com>
In-Reply-To: <48A75E72.7050508@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> C
> Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6be3

A pointer was dereferenced in an object that was already freed.

