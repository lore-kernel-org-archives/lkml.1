Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYBZRjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYBZRjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761549AbYBZRjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:39:12 -0500
Received: from lazybastard.de ([212.112.238.170]:50257 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbYBZRjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:39:11 -0500
Date: Tue, 26 Feb 2008 18:38:19 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226173819.GC23829@lazybastard.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <20080226140925.GB20428@lazybastard.org> <20080226152810.GB18118@shareable.org> <20080226170214.GA23829@lazybastard.org> <20080226172913.GB22471@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226172913.GB22471@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 February 2008 17:29:13 +0000, Jamie Lokier wrote:
> 
> You're right.  Though, doesn't normal page writeback enqueue the COW
> metadata changes?  If not, how do they get written in a timely
> fashion?

It does.  But this is not sufficient to guarantee that the pages in
question have been safely committed to the device by the time
sync_file_range() has returned.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
