Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZDOERv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZDOERv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZDOERm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:17:42 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:48367 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZDOERm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vEhn+R/2CNBmmMWmoaICAhY1jat9xH0xT0ZYMkGzuEq46ScXIRM+Ao3YUmR+5+ZXOq
         H3+yUY1f/dUXF+/3I+a+Q7wlx+VyjTIcKoBDnUQRIVTL8coXpfsQZH+FZTuDV1j3HN77
         pAF1+rLCthlqhN6HOzSdj8hTIi3SDCkR3LT04=
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
In-Reply-To: <49E5349A.9080402@cn.fujitsu.com>
References: <1239610670.6660.49.camel@tropicana>
	 <20090414205635.GA5968@nowhere>  <49E5349A.9080402@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 23:17:38 -0500
Message-Id: <1239769058.7852.6.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 09:12 +0800, Li Zefan wrote:
> > Ok, the whole design and concept looks nice.
> > 
> > But you really need to think about a locking scheme to protect
> > the filters from user files.
> > 
> 
> I noticed this and fixed it in that
> 	"[PATCH 7/7] tracing/filters: make filter preds RCU safe"
> 
> I'll try to fix it on top of Tom's on-the-fly filter swithcing,
> if Tom hasn't started to do this.
> 

No, I hadn't gotten to it yet - feel free to do it if you want,
otherwise I'll get to it soon...

Thanks,

Tom

> > Also, is filter_add_pred() supposed to be available for in-kernel
> > uses by other tracers or something?
> > If this is planned, the locking could be even deeper than my comments.
> > 
> > Other than these comments:
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Thanks!

