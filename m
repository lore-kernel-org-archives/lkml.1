Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbZJOMyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbZJOMyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbZJOMyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:54:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49637 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbZJOMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ABo6HwjDePP/AlQe6vjkVdZ/Ee3NcaN7K9xUeFrs9d3ZWvp+Hbmledh11GbuPLh5s2
         rZ9UpDsu8334YNOtUSEzNIRO74Hpb09yErLDy1HiXw/iK1Xp81RZqX6rmVXY507c1szY
         N925zto496Ocrn5R3COd6WcuFkZuf3aGkV6tI=
Date: Thu, 15 Oct 2009 14:52:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] tracing/filters: Use a different op for glob match
Message-ID: <20091015125207.GC4960@nowhere>
References: <4AD694B8.2020206@cn.fujitsu.com> <4AD69528.3050309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD69528.3050309@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:21:12AM +0800, Li Zefan wrote:
> "==" will always do a full match, and "~" will do a glob match.
> 
> In the future, we may add "=~" for regex match.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Thanks a lot for doing this. I can then remove it from my
TODO list :)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

