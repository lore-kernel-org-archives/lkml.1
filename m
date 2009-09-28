Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbZI1JIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbZI1JIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZI1JIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 05:08:48 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54694 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZI1JIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 05:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eSwr0dhxYu7+Q7dPD8judeUFkbxYtVHmnyh41KoM3zeIC//tfVAo44i0qXoPzPpQep
         gPvIjhHdfgqj/KlxGK82V5Y4vyA3StkJqSePtF0prJ+vvSDMt/OSxHjXYmDbvVqkl/CB
         4L8bBQMCv9x7wncQSPBefGgbo09RF2mae01FQ=
Date: Mon, 28 Sep 2009 11:08:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Fix up tracer registration.
Message-ID: <20090928090848.GC6142@nowhere>
References: <20090928075540.GD6668@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928075540.GD6668@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:55:40PM +0900, Paul Mundt wrote:
> Commit ddc1637af217dbd8bc51f30e6d24e84476a869a6
> ("kmemtrace: Print binary output only if 'bin' option is set") ended up 
> inverting the error detection logic. register_tracer() returns 0 on
> success, which this change caused to treat as an error, resulting in:
> 
> [    0.132000] Warning: could not register the kmem tracer
> 
> as well as bailing out of the initcall with an error value. This
> restores the old logic.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

