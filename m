Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0BRMMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:12:30 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35255 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0BRMM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g0GQMNJl4gTMMDzot6ZW88EvncmUaVuoUI4CxUKoKS3ixPCJWzQAYF97cS6YmNuH+j
         vt55a5YZf49t4HH9SnNJ93IjQFqFgK0HshR+wVJboJs0CjXZe2Ov8RhXurD8+R8e/RDF
         dONY12kqvlbyZflxjnETEdsEo5cQc7hHHE3yI=
MIME-Version: 1.0
In-Reply-To: <20100218120944.GA2406@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> 
	<1266491616-6270-3-git-send-regression-fweisbec@gmail.com> 
	<8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> 
	<20100218120944.GA2406@osiris.boeblingen.de.ibm.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Feb 2010 07:12:08 -0500
Message-ID: <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:09, Heiko Carstens wrote:
> On Thu, Feb 18, 2010 at 06:18:20AM -0500, Mike Frysinger wrote:
>> On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
>> > --- a/arch/Kconfig
>> > +++ b/arch/Kconfig
>> > @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
>> >  config USE_GENERIC_SMP_HELPERS
>> >        bool
>> >
>> > +config HAVE_REGS_AND_STACK_ACCESS_API
>> > +       bool
>> > +
>>
>> could you add an appropriate help/comment so arch peeps know what
>> needs to be implemented before they can select this
>
> That's why I added the commit ID for the regs and stack access api
> to the changelog. imho that should be sufficient.
> Besides that the next commit would implement it for s390 as a
> blueprint for others. That is... for those that missed the initial
> x86 implementation.

people shouldnt have to dive into the changelog to try and divine
documentation.  it's hardly standard, so people fall on it in a
pima-last-resort kind of way.  being explicit in the file up front by
writing real documentation says other people a lot more time.
-mike
