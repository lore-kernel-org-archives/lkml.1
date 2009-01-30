Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbZA3Aic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbZA3Aic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZA3AiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:38:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:22954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbZA3AiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TL0JfBHCkotaLZRMaQWFCDHaDauU3+WFe3vdDRKqGZxuOCwU8a/1y5uee4gN2R3ruM
         2lJCM6P7OdA0NqNUvPOyeTRYGP1TFqD1uhhcZ3+xCrat3mR9o9AJiM6TIizXZWw/DbhY
         FVEo+iXXMSgAgVR4P0dHlkokgx5Lafcgx5Iu0=
Date: Fri, 30 Jan 2009 01:38:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net
Subject: Re: [PATCH] tracing/ftrace: add an option to not print the context
	info for events
Message-ID: <20090130003818.GB5862@nowhere>
References: <497671d4.1358560a.7a83.6114@mx.google.com> <20090129161956.9158e9c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129161956.9158e9c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 04:19:56PM -0800, Andrew Morton wrote:
> On Tue, 20 Jan 2009 16:52:36 -0800 (PST)
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +		usec_rem = do_div(t, 1000000ULL);
> 
> The second argument to do_div() is in fact a u32.  It's quite hard to
> track this down due to use of macros and lack of comemnts.
> 
> Doing
> 
> 	usec_rem = do_div(t, USEC_PER_SEC);
> 
> would suit here.


Thanks, I've fixed it for the next version of this patch.

