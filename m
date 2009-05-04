Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZEDOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZEDOks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZEDOk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:40:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:36469 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbZEDOkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Pgq6JkHQt2B2w5oUZx6ddkg6YZPVDFa/q7fGNXhEFKmooZpKHSHX6Yt1vyPFpNlTbk
         v7956pvN+1Jcpr0G9kckTh9sGFKkP+KX6glC3uTaC8nCjmPIvgW7HN7n/toqXzujuHev
         vFXIjKDY3M7/R12GSwXH+7VGAhwWO9XLVKpCY=
MIME-Version: 1.0
In-Reply-To: <20090502024719.GA29730@localhost>
References: <200904302208.n3UM8t9R016687@imap1.linux-foundation.org>
	 <20090501012212.GA5848@localhost>
	 <20090430194907.82b31565.akpm@linux-foundation.org>
	 <20090502023125.GA29674@localhost> <20090502024719.GA29730@localhost>
Date: Mon, 4 May 2009 23:40:18 +0900
X-Google-Sender-Auth: 3cc249b2e443da7c
Message-ID: <2f11576a0905040740m779464fdobd435a9b88a4ae67@mail.gmail.com>
Subject: Re: [RFC][PATCH] vmscan: don't export nr_saved_scan in /proc/zoneinfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The lru->nr_saved_scan's are not meaningful counters for even kernel
> developers.  They typically are smaller than 32 and are always 0 for
> large lists. So remove them from /proc/zoneinfo.
>
> Hopefully this interface change won't break too many scripts.
> /proc/zoneinfo is too unstructured to be script friendly, and I wonder
> the affected scripts - if there are any - are still bleeding since the
> not long ago commit "vmscan: split LRU lists into anon & file sets",
> which also touched the "scanned" line :)
>
> If we are to re-export accumulated vmscan counts in the future, they
> can go to new lines in /proc/zoneinfo instead of the current form, or
> to /sys/devices/system/node/node0/meminfo?
>
> CC: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
