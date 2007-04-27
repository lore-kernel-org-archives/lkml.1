Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbXD0KWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbXD0KWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXD0KWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:22:16 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:29849 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755569AbXD0KWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:22:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=w4B6NJDYgdQbiHlqh21O3cSC8TEEdj17nndHbTBRZVTpF8tY9w5IXoxnmgJn4wEobH2JbQJE5kd+Lvss84ZOESStWA2DLZmilZzrdirtsTspWuWAGuEaAjV/NcddV2sfn4cWfUzXiKklNA/k4phWf8Gw1BjNhEF8Jw3aJfBC0Rc=  ;
X-YMail-OSG: sntqw1oVM1nUKA08Z7xaF9jC5YxRAUVeGsNOuIRy0axkomorLqDTFWRTZ05eGGbQ.rW4gmKuzQ--
Message-ID: <4631CECF.4030301@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:22:07 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com> <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com> <20070427003216.GM19966@holomorphy.com>
In-Reply-To: <20070427003216.GM19966@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III <wli@holomorphy.com> writes:
> 
>>>In memory as on disk, contiguity matters a lot for performance.
> 
> 
> On Thu, Apr 26, 2007 at 12:21:24PM -0600, Eric W. Biederman wrote:
> 
>>Not nearly so much though.  In memory you don't have seeks to avoid.
>>On disks avoiding seeks is everything.
> 
> 
> I readily concede that seeks are most costly. Yet memory contiguity
> remains rather influential.
> 
> Witness the fact that I'm now being called upon a second time to
> adjust the order in which mm/page_alloc.c returns pages for the
> sake of implicitly establishing IO contiguity (or otherwise
> determining why things are coming out backward now).

Just a random aside question... doesn't Oracle db do direct IO from
hugepages?

-- 
SUSE Labs, Novell Inc.
