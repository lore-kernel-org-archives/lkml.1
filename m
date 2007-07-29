Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXG2POg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXG2POg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765320AbXG2PBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:01:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765233AbXG2PBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:01:45 -0400
Message-ID: <46ACABBF.10406@redhat.com>
Date: Sun, 29 Jul 2007 11:01:19 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Al Boldi <a1426z@gawab.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: How can we make page replacement smarter
References: <200707272243.02336.a1426z@gawab.com>	<46AAA25E.7040301@redhat.com>	<200707280717.41250.a1426z@gawab.com>	<46ABF184.40803@redhat.com> <20070729140936.6cd364a9@the-village.bc.nu>
In-Reply-To: <20070729140936.6cd364a9@the-village.bc.nu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Files are different.  File content tends to be grouped
>> in large related chunks, both logically in the file and
>> on disk.  Generally there is a lot more file data on a
>> system than what fits in memory.
> 
> Binary paging patterns don't always look like that unfortunately although
> I suspect we might want to be weighing towards paging out R/O file mapped
> pages earlier simply because they are bigger linear chunks

A properly implemented use-once algorithm should be able
to filter out the spatial locality of reference pages from
the temporal locality of reference ones, though...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
