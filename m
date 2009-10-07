Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbZJGIMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbZJGIMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbZJGIMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:12:18 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49879 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336AbZJGIMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ISemvUmGflFcdeiTanq77VNnc/OhuM7Ns79r50TJ1r9Z7vS2F/f7Rfu4ZOUbYe/zEn
         GWbqfI54/AgSD8lAJPS4N/fuKniMNITrK5c/SQTtGLxPzUaVUr3vuezl1A6TQ0RIUUQB
         cmLhPsk2oa9Wyn1l8v0/0TG8hg7TWkihGz1z0=
Date: Wed, 7 Oct 2009 10:11:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] perf tools: Merge trace.info content into
	perf.data
Message-ID: <20091007081134.GA5043@nowhere>
References: <20091006213643.GA5343@nowhere> <20091007062204.GE21673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007062204.GE21673@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:22:04AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > Here is an attempt to remove the trace.info file. It works well for 
> > me, the reason for it to be an RFC is that I have doubts about the 
> > backward compatibility.
> > 
> > A file created by perf after his patch is unsupported by previous 
> > version because the size of the headers have increased.
> 
> That's OK i think in terms of trace.info - trace.info was a temporary 
> hack to begin with.



Ok.


 
> > That said, it's two new fields that have been added in the end of the 
> > headers, and those could be ignored by previous versions if they just 
> > handled the dynamic header size and then ignore the unknow part. The 
> > offsets guarantee the compatibility.
> 
> Yes, that's how it should work.
> 
> > But previous versions handle the header size using its static size, 
> > not dynamic, then it's not backward compatible.
> > 
> > Anyway, I'm not sure exactly how to handle that.
> 
> That's a bug in the previous version - mind doing a standalone fix for 
> that so we can mark it Cc: stable?
> 


Ok, preparing this.

Thanks.

