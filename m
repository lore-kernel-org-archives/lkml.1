Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbZDOB4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbZDOB4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZDOBzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:55:52 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53776 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbZDOBzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IjCpWVytm1yIjr/EtVl2s9YMK0ZYXloWreuTTU8ryVXvEdkD73hgO4i3ytFMrvjTee
         Rzw7BH1oPSN9GP+5AEbhHILESVRwD4acxk67dK7DPY4WG98Pc+oRb8Z2gV+gk6xaGgN+
         uEh2WMJiGCrqQt5xFOD7/yEMEI/K+TWkvPEAQ=
Date: Wed, 15 Apr 2009 03:55:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
Message-ID: <20090415015547.GJ5968@nowhere>
References: <1239610670.6660.49.camel@tropicana> <20090414205635.GA5968@nowhere> <49E5349A.9080402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5349A.9080402@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 09:12:58AM +0800, Li Zefan wrote:
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


Ah, ok.

Thanks.

 
> > Also, is filter_add_pred() supposed to be available for in-kernel
> > uses by other tracers or something?
> > If this is planned, the locking could be even deeper than my comments.
> > 
> > Other than these comments:
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Thanks!

