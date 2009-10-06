Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZJFPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZJFPFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZJFPFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:05:52 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:39875 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZJFPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=glmLEF+tJ4FpssjDW5vMueXAdgv8e1jXMhFE3PqPg9ON3A/puhUWb6KWsCUuqpb69U
         +nkGphwG3vZil7P9A5uCTHlAbnEH1xg5EJSJBhQD2lrdUlFtVAHVBMAk1fRIiPVO223Q
         iNwiDqEv3rjfdwopB8nihI1wDhB3uXbrcMOEs=
Date: Tue, 6 Oct 2009 17:05:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tracing/events: Add 'signed' field to format
	files
Message-ID: <20091006150510.GA5152@nowhere>
References: <1254809398-8078-2-git-send-email-tzanussi@gmail.com> <tip-26a50744b21fff65bd754874072857bee8967f4d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-26a50744b21fff65bd754874072857bee8967f4d@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 01:06:39PM +0000, tip-bot for Tom Zanussi wrote:
> Commit-ID:  26a50744b21fff65bd754874072857bee8967f4d
> Gitweb:     http://git.kernel.org/tip/26a50744b21fff65bd754874072857bee8967f4d
> Author:     Tom Zanussi <tzanussi@gmail.com>
> AuthorDate: Tue, 6 Oct 2009 01:09:50 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Oct 2009 15:04:45 +0200
> 
> tracing/events: Add 'signed' field to format files
> 
> The sign info used for filters in the kernel is also useful to
> applications that process the trace stream.  Add it to the format
> files and make it available to userspace.



This is something we could already find using the type of
the field.

Also I wonder if that breaks the format definition ABI. I mean:
event formats are not ABI, except for the TRACE_EVENT_ABI.
But concerning how we describe the format description, I
have doubts.

As an example, I don't know if this patch would break 2.6.32-rc1
(and then 2.6.32) based perf tools running on a future 2.6.33
kernel.

