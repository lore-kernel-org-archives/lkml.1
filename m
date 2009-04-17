Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbZDQSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbZDQSKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932177AbZDQSK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:10:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbZDQSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:10:26 -0400
Message-ID: <49E8C570.7030708@zytor.com>
Date: Fri, 17 Apr 2009 11:07:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com> <1239058135.5212.43.camel@localhost.localdomain> <49DA8857.8030607@zytor.com> <49E7BFDC.8040305@redhat.com> <49E7C1B3.1070000@zytor.com> <49E884C2.9030409@redhat.com>
In-Reply-To: <49E884C2.9030409@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> 
> Aah, I see. So we'd better make a parser which generates internal
> data structure from genuine opcode map in compilation time.
> 
> And I changed my mind about internal data structure too.
> In this version, I'll use a smallest bits which are needed
> for the decoder.
> 

Yes, and with a proper compile-time parser, that kind of things can be
done, and be changed later if it is no longer appropriate.

	-hpa
