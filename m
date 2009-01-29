Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbZA2WHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbZA2WHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbZA2WHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:07:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:57080 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759589AbZA2WHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:07:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pLK33QVIjx0G04E3EzWNnExHGAGdvJJo/lJkXcQGbBAavQhnpLbxU1OUWi5X3DWxM/
         1D9VkiZkQXcpdUVuzPuLR4R+C9eIPicevykQ9eZ9NPCqUOwzhi10vK6jHXlZ08/BEQNl
         CnH0Y1gTCu2BqH8JRUag2l/RoRMgCdSn8o7Sk=
MIME-Version: 1.0
In-Reply-To: <1233263200.3937.44.camel@perihelion.bos.jonmasters.org>
References: <alpine.DEB.1.10.0812161556460.25356@gandalf.stny.rr.com>
	 <1233263200.3937.44.camel@perihelion.bos.jonmasters.org>
Date: Thu, 29 Jan 2009 14:07:01 -0800
X-Google-Sender-Auth: bd8809e80af51851
Message-ID: <1f1b08da0901291407q7aeaa13es730bad17abda9b66@mail.gmail.com>
Subject: Re: Creating the RT git tree
From: john stultz <johnstul@us.ibm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 1:06 PM, Jon Masters <jonathan@jonmasters.org> wrote:
> *). I might not be the best git user on the planet (trying to fix that)
> but I would really like to just see the patches that are specific to a
> given topic branch, without the merge noise. For example, a git log on
> the threadirqs branch shows me all the other patches in linus' tree as
> merges are done. I could do a git log --grep="threadirqs" but is there a
> better way? How do I instruct git to show me just the patches added
> specifically in threadirqs?

This seems to work for me:
  git log -r origin/linus..origin/rt/threadirqs

Although git show doesn't seem to like that.

thanks
-john
