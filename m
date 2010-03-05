Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0CETjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:39:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0CETjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:39:42 -0500
Subject: Re: [PATCH 06/14] perf, x86: PEBS infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Paul Mackerras <paulus@samba.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <bd4cb8901003051111h4ef4de03i426dc82c7e25b8d3@mail.gmail.com>
References: <20100304140046.596569763@chello.nl>
	 <20100304140100.392111285@chello.nl>
	 <20100305061942.GF27606@brick.ozlabs.ibm.com>
	 <1267780810.16716.51.camel@laptop>
	 <bd4cb8901003051111h4ef4de03i426dc82c7e25b8d3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 20:39:39 +0100
Message-ID: <1267817979.4942.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 11:11 -0800, Stephane Eranian wrote:
> By rewinding you get the IP of the instruction that caused the event. But the
> register state is STILL reflecting the situation at retirement of that
> instruction. 

I'm quite aware of that, but its near impossible to reverse interpret
instructions such as "mov rdx, $rdx", so until we get fault like PEBS
we'll just have to live with this.

