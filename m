Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZDOBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZDOBMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZDOBMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:12:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54819 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbZDOBMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:12:14 -0400
Message-ID: <49E5349A.9080402@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 09:12:58 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
References: <1239610670.6660.49.camel@tropicana> <20090414205635.GA5968@nowhere>
In-Reply-To: <20090414205635.GA5968@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, the whole design and concept looks nice.
> 
> But you really need to think about a locking scheme to protect
> the filters from user files.
> 

I noticed this and fixed it in that
	"[PATCH 7/7] tracing/filters: make filter preds RCU safe"

I'll try to fix it on top of Tom's on-the-fly filter swithcing,
if Tom hasn't started to do this.

> Also, is filter_add_pred() supposed to be available for in-kernel
> uses by other tracers or something?
> If this is planned, the locking could be even deeper than my comments.
> 
> Other than these comments:
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks!
