Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbZD2Huy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbZD2Huy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbZD2HsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:48:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:59075 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbZD2HsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rXTNQpZX+kZYfS47XtofU1AosSODwDgZfiBrGEFGbvLx4u1Pir34+lXcVhYqZwEEpk
         Ql5LBkjfySzYELbtVmcqHy1uLQsVORHRoqHyDs+tnr0mUTeVKMmqo64cxJUYB72VCr7z
         5MKZW1OhNnS7yQYDT7vpeYTaui0bGFI0i3A+k=
MIME-Version: 1.0
In-Reply-To: <20090429130430.4B11.A69D9226@jp.fujitsu.com>
References: <20090428090916.GC17038@localhost> <20090428120818.GH22104@mit.edu>
	 <20090429130430.4B11.A69D9226@jp.fujitsu.com>
Date: Wed, 29 Apr 2009 16:48:05 +0900
X-Google-Sender-Auth: 4ed6ed3ec16d45ea
Message-ID: <2f11576a0904290048m5a33e8a8j76c9a7ae067f8c83@mail.gmail.com>
Subject: Re: Swappiness vs. mmap() and interactive response
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Theodore Tso <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one mistake

> mouse move lag:               not happend
> window move lag:              not happend
> Mapped page decrease rapidly: not happend (I guess, these page stay in
>                                          active list on my system)
> page fault large latency:     happend (latencytop display >200ms)

             ^^^^^^^^^

            >1200ms

sorry.
