Return-Path: <linux-kernel-owner+w=401wt.eu-S1750868AbZJHECO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750868AbZJHECO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 00:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZJHECO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 00:02:14 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:41969 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZJHECN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 00:02:13 -0400
X-Greylist: delayed 84692 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 00:02:13 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q4dulZJfyMgRBRrdIX13uyRMd40NjgoSTOg6qfShrnolbXt9runk5+QoWoK9S0ZbZP
         yHS3857jT6WYFjcjcNdzPMv/7+9KRITIG5LUf1v0N9QAn6n/BOqOPtv6QG9itucx8AYJ
         bHfD9EXSZi8lrfKcw5fCMH5/M/cTMlGvSW2k8=
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
From: Tom Zanussi <tzanussi@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com
In-Reply-To: <20091007141332.GA21320@infradead.org>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <1254809398-8078-6-git-send-email-tzanussi@gmail.com>
	 <20091006130059.GD15320@elte.hu> <1254888565.28917.135.camel@tropicana>
	 <20091007141332.GA21320@infradead.org>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 23:01:33 -0500
Message-Id: <1254974493.6841.17.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 10:13 -0400, Christoph Hellwig wrote:
> On Tue, Oct 06, 2009 at 11:09:25PM -0500, Tom Zanussi wrote:
> > > I think we also want to have a 'perf -s *' kind of thing to get a list 
> > > of all available language modules.
> > > 
> > 
> > I knew somebody would point that out (and suggest a better way ;-)  That
> > all makes sense - I'll make these changes in the next version.
> 
> I'm a bit worried about linking two million scripting language into the
> main perf binary.  Can't we just have seaprate perlperf / pythonperf,
> rubyperf, awkperf binaries that only contain the scripting support?
> 

Yeah, that's a good point.  Maybe support for each language should be
implemented as shared library 'plugins', where the right one gets loaded
dynamically using dlopen/dlsym based on the type of script invoked or
command-line option used.  I'll try something like that for the next
version.

Tom

