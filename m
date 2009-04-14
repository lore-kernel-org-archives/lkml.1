Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZDNVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZDNVgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZDNVg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:36:26 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:47177 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbZDNVgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:36:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=elastic.org;
	h=Received:Received:Received:Date:From:To:Subject:Message-ID:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	b=i66/KkSlSfTRgwpWOZvKEiptqVPpYXRyOsJ3s5RUZw7tlHB7cAG1tH1bfbKdYQSUQZGRC+jQS4v5yNFaOsMo1sLwJofgrBcNP3DNeokAahjMl5skhLLcvSHQIWyWv7s0;
Date: Tue, 14 Apr 2009 17:29:17 -0400
From: "Frank Ch. Eigler" <fche@elastic.org>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jiaying Zhang <jiayingz@google.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090414212917.GA19933@elastic.org>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414210445.GM955@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Apr 14, 2009 at 05:04:45PM -0400, Theodore Tso wrote:
> [...]
> One thing which I would really like is to avoid needing to drop the
> header file in include/trace/<subsystem.h>.
> 
> The problem that I have with this is that for ext4, we need to access
> private data structures which are defined in header files in
> fs/ext4/*.h --- which we moved into fs/ext4 a long time ago [...]

If the tracepoints/events expand to code that exposes those private
structures, then those structures are perhaps not quite so private any
more.  That argues for moving those headers back under include/..., or
at least those type decls made reachable from the tracepoints.

- FChE
