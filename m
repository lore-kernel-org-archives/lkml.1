Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZJOPEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZJOPEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762779AbZJOPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762778AbZJOPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:04:07 -0400
Message-ID: <4AD739A0.6010707@redhat.com>
Date: Thu, 15 Oct 2009 11:02:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] swap_info: change to array of pointers
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils> <Pine.LNX.4.64.0910150146210.3291@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0910150146210.3291@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> The swap_info_struct is only 76 or 104 bytes, but it does seem wrong
> to reserve an array of about 30 of them in bss, when most people will
> want only one.  Change swap_info[] to an array of pointers.
> 
> That does need a "type" field in the structure: pack it as a char with
> next type and short prio (aha, char is unsigned by default on PowerPC).
> Use the (admittedly peculiar) name "type" throughout for this index.
> 
> /proc/swaps does not take swap_lock: I wouldn't want it to, but do take
> care with barriers when adding a new item to the array (never removed).
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
