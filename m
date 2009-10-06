Return-Path: <linux-kernel-owner+w=401wt.eu-S932705AbZJFOLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbZJFOLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932685AbZJFOLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:11:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbZJFOLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:11:07 -0400
Subject: Re: [PATCH 0/4] jump label patches
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       ak@suse.de, rth@redhat.com, mhiramat@redhat.com
In-Reply-To: <20091006060410.CAF2528@magilla.sf.frob.com>
References: <cover.1253831945.git.jbaron@redhat.com>
	 <20091006060410.CAF2528@magilla.sf.frob.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 06 Oct 2009 10:09:08 -0400
Message-Id: <1254838148.13160.224.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 23:04 -0700, Roland McGrath wrote:
> I think text_poke_fixup() is a good safe place to start, and it seems wise
> to merge a version using that before worrying anything subtler.  But it's
> almost surely overkill and makes the enable/disable switching cost pretty
> huge.  The rules as documented by Intel seem to indicate that simple
> self-modification can work for UP and for SMP there should be some scheme
> with IPIs that is not too terrible.  
> 

I think this is still under discussion. The thread about immediates
seems to express some concern.

  http://lkml.org/lkml/2009/9/24/134

-- Steve


