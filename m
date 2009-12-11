Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbZLKLEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbZLKLEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZLKLEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:04:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62701 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZLKLEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LiiSTg9mJ0zCiZP/Bh6JZ+1aJO6YMLQj+mn9T+VrktjrLxaORmuhIaUSLBPGCJraMH
         RdH5G0syEZNBTpgAuzuNrS4e34ycnp0WWLf7SuRc09AVvYn3Pe5reUNN3+p1kbCZE0WI
         rKpFNGGurDPl5Pv8uqSxd6KzIdhp5q20sQmys=
Date: Fri, 11 Dec 2009 12:04:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Return value of print_graph_prologue
Message-ID: <20091211110444.GA5244@nowhere>
References: <4B221B0F.6040107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B221B0F.6040107@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 06:12:31PM +0800, Wenji Huang wrote:
> Hi,
>
> I got confused about the return value of print_graph_prologue. See:
>
> 805         /* Latency format */
> 806         if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> 807                 ret = print_graph_lat_fmt(s, ent);
> 808                 if (ret == TRACE_TYPE_PARTIAL_LINE)
> 809                         return TRACE_TYPE_PARTIAL_LINE;
> 810         }
> 811
> 812         return 0;
> 813 }
>
> But we have defined TRACE_TYPE_PARTIAL_LINE = 0. So there's
> no difference between success and failure?
>
> Should it be TRACE_TYPE_HANDLED ?
>
> Regards,
> Wenji


Oh, good catch, I'm preparing a fix.

Thanks.

