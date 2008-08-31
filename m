Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYHaSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYHaSh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYHaShR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:37:17 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:21879 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYHaShQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=o61ZaSvMM0tHrTF/sXrAsqnbQhoOmDAB8+EHuEfrK6xlhgvfItStIDx7fDWn7cwxMQ
         72QCEYb9SPzJobZxx9MF8hMqd59aHN3s27odG+hkI7XS86pO+xQvzCIFs+lwtfQhTbi2
         rBnn1Gt1juz78W89g9iyHBBH8/e58vNy6BSJU=
Date: Sun, 31 Aug 2008 21:36:52 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rdunlap@xenotime.net,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH] kmemtrace: SLUB hooks for caller-tracking functions.
Message-ID: <20080831183652.GA5220@localhost>
References: <1219600175-5253-1-git-send-email-eduard.munteanu@linux360.ro> <48BAAC3C.4050309@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BAAC3C.4050309@cs.helsinki.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 05:35:40PM +0300, Pekka Enberg wrote:
> Eduard - Gabriel Munteanu wrote:
>> This patch adds kmemtrace hooks for __kmalloc_track_caller() and
>> __kmalloc_node_track_caller(). Currently, they set the call site pointer
>> to the value recieved as a parameter. (This could change if we implement
>> stack trace exporting in kmemtrace.)
>> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
>
> Applied. I had to do some manual tweaking, so can you please double-check 
> the result:
>
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=b9f1ecc6428f0ba391845b2ac7df8618da287e4f
>
> Thanks!

Looks fine to me. However, you can now remove the casts to unsigned long
from 'caller', i.e. "s/(unsigned long) caller/caller/g"

