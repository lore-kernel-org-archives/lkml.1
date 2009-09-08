Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbZIHS5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbZIHS5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZIHS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZIHS5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:57:12 -0400
Message-ID: <4AA6A8FC.9080301@redhat.com>
Date: Tue, 08 Sep 2009 14:57:00 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/8] mm: add get_dump_page
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072231120.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072231120.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> In preparation for the next patch, add a simple get_dump_page(addr)
> interface for the CONFIG_ELF_CORE dumpers to use, instead of calling
> get_user_pages() directly.  They're not interested in errors: they
> just want to use holes as much as possible, to save space and make
> sure that the data is aligned where the headers said it would be.
> 
> Oh, and don't use that horrid DUMP_SEEK(off) macro!
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
