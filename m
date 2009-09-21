Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbZIUSrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbZIUSrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZIUSrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:47:48 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53452 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZIUSrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OUtPH/Xaj51hdKZrdTjON6qiMJJSBebKNI3XDAtLkG4H0lk9tKYcYKAPmLZPHXL9Ez
         CkR+2qUb/Levr3Xfh4jXe9ZexBJp1Ujwe2lRTxIb2hLpfmGt/AlzHNhs8S4pHMP6TQEH
         LbpgZ7f1DznIBWGXp58hhuSVAXlMWQvCbiuFs=
Date: Mon, 21 Sep 2009 20:47:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/events: use list_for_entry_continue
Message-ID: <20090921184745.GC5018@nowhere>
References: <4AB32364.7020602@cn.fujitsu.com> <4AB32389.1030005@cn.fujitsu.com> <20090918150930.GB5200@nowhere> <4AB6E651.6050000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB6E651.6050000@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:34:57AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Fri, Sep 18, 2009 at 02:07:05PM +0800, Li Zefan wrote:
> >> Simplify s_next() and t_next().
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> >> ---
> > 
> > Nice.
> > I wonder if that can be even more simplified with
> > the following existing seq helpers:
> > 
> 
> Unfortunately they can't be used here, at least they can't
> help make code simpler, because we need to skip some list
> entries.
> 
> But we can add seq_list_start_at() and seq_list_next_at(),
> which take a predicate and will return an entry which matches
> the predicate. I thought about it, and I can try it out.


Why not, if the pattern is already met by other subsystems.
Otherwise I guess it's not needed.

Thanks.

