Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYHSShK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYHSShK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYHSSg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:36:57 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:59466 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYHSSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=QRLcir9/RtIHP7p12EvYvFdlk0NmDU+CD8B+ViXVFwByaFuF5KJxkDihZr5tU3ntYl
         PNPYby84DKUZtuVZrM6dGFIobyO/nPJpEnK+9H1JZH9mTQGgKDDH71RgOQ+0qftwr5ei
         eNUcStmclTrkqxUE8MtL3SHdysajb+msoEK9Y=
Date: Tue, 19 Aug 2008 21:32:03 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
       tglx@linutronix.de, rostedt@goodmis.org, cl@linux-foundation.org,
       tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
Message-ID: <20080819183203.GB5520@localhost>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <Pine.LNX.4.64.0808191049260.7877@shark.he.net> <20080819175440.GA5435@localhost> <20080819181652.GA29757@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819181652.GA29757@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 02:16:53PM -0400, Mathieu Desnoyers wrote:
> Question :
> 
> Is this kmemtrace marker meant to be exposed to userspace ?
> 
> I suspect not. In all case, not directly. I expect in-kernel probes to
> be connected on these markers which will get the arguments they need,
> and maybe access the inner data structures. Anyhow, tracepoints should
> be used for that, not markers. You can later put markers in the probes
> which are themselves connected to tracepoints.
> 
> Tracepoints = in-kernel tracing API.
> 
> Markers = Data-formatting tracing API, meant to export the data either
> to user-space in text or binary format.
> 
> See
> 
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=shortlog
> 
> tracepoint-related patches.

I think we're ready to try tracepoints. Pekka, could you merge Mathieu's
tracepoints or otherwise provide a branch where I could submit a
tracepoint conversion patch for kmemtrace?

> Mathieu
> 
