Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZDQAKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZDQAKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbZDQAKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:10:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZDQAKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:10:24 -0400
Message-ID: <49E7C87E.8000202@zytor.com>
Date: Thu, 16 Apr 2009 17:08:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 3/6 V4.1] x86: instruction decorder API
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>	 <1239058135.5212.43.camel@localhost.localdomain>	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com> <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>
In-Reply-To: <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> 
> It looks like AT2(Ev,Gv) would yield the same bits as AT2(Gv,Ev).  It'd
> be nice not to lose the operand-order information.  And we'd have to
> make clear whether which notation we're using -- src,dest as in the gnu
> assembler, or dest,src as in the AMD (and Intel?) manuals.
> 

Since the information would come from the manuals, I would recommend 
following them (dst first.)

	-hpa

