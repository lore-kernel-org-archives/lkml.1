Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbZE0Nr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbZE0Nr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbZE0Nrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:47:43 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:60242 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763424AbZE0Nrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a76qy1KQbf1UDIZL2rhditujPb/PXN/T1x/hLY2TUCmdmZtQ6KWh6+hN6j+kl287Fw
         zbg/0eaEigjbE6CWxe2LMKGRwbqJ4PuW7tfSIyYZjZmCXGeDxrDLgX/82jR68CyZWDag
         MzhGktqPS4hnBcMANc9XR53NKmA3e9CjTBVk4=
Date: Wed, 27 May 2009 15:47:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't convert function's local variable name
	in macro
Message-ID: <20090527134738.GB5982@nowhere>
References: <4A1D41C2.2010903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D41C2.2010903@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:36:02PM +0800, Zhaolei wrote:
> "call" is a argument of macro, but it is also used as a local variable name of
> function in macro.
> We should keep this local variable name static although it haven't cause
> problem now.
> 
> [ Impact: cleanup, no functionality changed ]
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>


Indeed, that can prevent unexpected things in the future.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

