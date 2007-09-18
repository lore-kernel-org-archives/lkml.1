Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbXIRTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbXIRTyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXIRTyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:54:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46572 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXIRTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:54:39 -0400
Message-ID: <46F02CF5.3060902@us.ibm.com>
Date: Tue, 18 Sep 2007 12:54:29 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Vara Prasad <prasadav@us.ibm.com>, linux-kernel@vger.kernel.org,
       SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [PATCH 0/2] A kernel tracing interface
References: <46E9CB0D.2040206@us.ibm.com> <20070914174953.04b0b158.akpm@linux-foundation.org> <46EFFF9D.6090609@us.ibm.com> <46F0026F.7030102@us.ibm.com> <20070918101327.91c5f24f.akpm@linux-foundation.org> <20070918175521.GA2915@Krystal>
In-Reply-To: <20070918175521.GA2915@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Andrew Morton (akpm@linux-foundation.org) wrote:
>> On Tue, 18 Sep 2007 09:53:03 -0700 Vara Prasad <prasadav@us.ibm.com> wrote:
>>
>>> This is part of the effort by the SystemTap team to move pieces of the 
>>> project that are generic to mainline.
>> Yeah.  It seems to have been reviewed to death.  Is it ready to
>> be applied yet?
> 
> I would just say that this could be seen rather as a driver tracing
> interface than a general purpose tracing interface. Therefore, maybe the
> name is a bit misleading ? And yes, what is there is good, but it does
> not seem to be a replacement for a generic kernel tracer.
> 
> My suggestions to turn it into a more suitable interface for a generic
> tracer are summarized in this email:
> http://lkml.org/lkml/2007/9/15/136
> 
> Mathieu
> 
Hi Mathieu
   Sorry I did not comment earlier on your email describing a generic 
tracer.  I believe that "trace" and your generic tracer could complement 
each other nicely.  The trace primitives could be expanded in the future 
to provide many of the features you described.  However, some of the 
features you describe are dependent on the format of the trace data 
itself (for example filtering), thus belong in a layer on top of trace.

Dave.
