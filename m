Return-Path: <linux-kernel-owner+w=401wt.eu-S937471AbXHJNph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937471AbXHJNph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbXHJNp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:45:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXHJNp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:45:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: jblunck@suse.de
Subject: Re: [PATCH 1/2] oprofile: Make callgraph use dump_trace() on i386/x86_64
Date: Fri, 10 Aug 2007 15:45:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070810133528.883477787@suse.de> <20070810133635.821996956@suse.de>
In-Reply-To: <20070810133635.821996956@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101545.22498.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2007 15:35:29 jblunck@suse.de wrote:
> This patch improves oprofile callgraphs for i386/x86_64. The old backtracing
> code was unable to produce even kernel backtraces if the kernel wasn't
> compiled with framepointers. The code now uses dump_trace().

Hmm one issue i didn't notice before: with imprecise backtrace
the profiling could be a little random because even if the same
call chain is hit repeatedly the garbage left over stack entries also
reported could vary and then cause oprofile to put it into different
buckets. But there is probably not much that can be 
done about that.

-Andi


