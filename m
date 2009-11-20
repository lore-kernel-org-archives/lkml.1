Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZKTWA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZKTWA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZKTWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:00:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:49012 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZKTWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:00:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tsbxxoGMFeyhpZCYLWVmXgpJgBUOCkQgjViAWDq8EphdzoHk90uvYDLbRKmBaOHBGa
         AH/4dtq6g3yl0/5qH1Stprz5f4atY0t6lQJvmj/FwBRZr825CGEKhAbbV+quqceR9xeh
         ousNI8Q7uyaVu6ZfphnO25Gd5lfR6dtC0evAM=
Date: Fri, 20 Nov 2009 23:00:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] perf: allow for custom overflow handlers
Message-ID: <20091120220025.GA4922@nowhere>
References: <20091120211942.676891948@chello.nl> <20091120212508.222339539@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120212508.222339539@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:19:43PM +0100, Peter Zijlstra wrote:
> in-kernel perf users might wish to have custom actions on the sample
> interrupt.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


I haven't yet answered to your previous message about using such
callback but yes, that's exactly the type of callback we want for
events that need to dispatch events in several different ways.

I'll try to use it for the hw-breakpoints.

Thanks.

