Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbZKSDIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbZKSDIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 22:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932327AbZKSDIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 22:08:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:14403 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZKSDID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 22:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QCV8I4qb1xln2ak6m30NHBggk0zF9FGmKs2DM/EPSorJI5IDMStzl9nMQd2MiVycni
         1vTSLfqZ4C5VLwcIXofvkrdoAp8VS3MiH+rdVfySzmoN4OpKWij6i27T0vTqo4sCeMVr
         4s28nggA58chFCAWEYACAMO6Fpn+iumdVHalY=
Date: Thu, 19 Nov 2009 04:08:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Stone <jistone@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: Remove the stale include/trace/power.h
Message-ID: <20091119030804.GC4970@nowhere>
References: <1258578415-14752-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258578415-14752-1-git-send-email-jistone@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 01:06:55PM -0800, Josh Stone wrote:
> Commit 6161352 moved the power tracing to include/trace/events/, but
> left the old header behind.  No one is using the old header, and its
> declarations are now incorrect, so it should be removed.
> 
> Signed-off-by: Josh Stone <jistone@redhat.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---



Yep, it has been completely replaced by the trace event version.
I guess we should take this one for .33

Thanks!

