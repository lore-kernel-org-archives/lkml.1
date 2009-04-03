Return-Path: <linux-kernel-owner+w=401wt.eu-S1764504AbZDCOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764504AbZDCOlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZDCOlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:41:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60513 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZDCOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:41:04 -0400
Message-ID: <49D61F09.2080808@cs.helsinki.fi>
Date: Fri, 03 Apr 2009 17:36:57 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie> <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop> <20090401152251.GB23390@elte.hu> <1238656331.26286.17.camel@penberg-laptop> <20090403042131.GA15669@localhost> <20090403141743.GF8875@elte.hu>
In-Reply-To: <20090403141743.GF8875@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
> 
>> One thing I'm not sure about this patch is whether it manages to 
>> record an allocation only once, i.e. does it log a single event 
>> when/if the slab allocator requests pages? Some time ago I sent a 
>> patch adding GFP_NOTRACE to gfp.h, but was rejected. Maybe this 
>> could be a way out of the mess.
>>
>> (GFP_NOTRACE would also allow us to log "backend" allocations 
>> easily and treat them separately, for the record, or simply filter 
>> them out.)
> 
> makes a lot of sense IMO to annotate these via a GFP flag.

Yup, make sense. I think I rejected the patch (did I?) because I wanted 
to fix the slub/slab mess differently but here it makes perfect sense.

			Pekka
