Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZCWIar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZCWIar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbZCWIa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:30:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757798AbZCWIaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:30:25 -0400
Message-ID: <49C748B0.20305@cn.fujitsu.com>
Date: Mon, 23 Mar 2009 16:30:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?GB2312?B?RnKopmSopnJpYyBXZWlzYmVj?= =?GB2312?B?a2Vy?= 
	<fweisbec@gmail.com>
Subject: Re: [PATCH] tracing/filters: use list_for_each_entry_safe
References: <1237796788.7527.35.camel@charm-linux>
In-Reply-To: <1237796788.7527.35.camel@charm-linux>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	list_for_each_safe(entry, tmp, &call->fields) {
> -		field = list_entry(entry, struct ftrace_event_field, link);
> +	list_for_each_entry_safe(field, next, &call->fields, link) {

Why we need _safe version ?

>  		if (!strcmp(field->name, name))
>  			return field;
>  	}

