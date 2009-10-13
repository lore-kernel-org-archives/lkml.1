Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbZJMI7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbZJMI7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 04:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbZJMI7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 04:59:21 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:51276 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZJMI7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 04:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SSVxeGULHXIPCPjOqnncoP/h/S+mm+qHOSRKn/HbwBAnpw8LCh5S5U1bfKjvGfx77x
         XgFwBm0efyOU+fY1aRzV291YyL8TUB7sYa5WgUDi8zviLvYWMIbatDaJRvCFO6C7yxw+
         xn26GXHlzm1CkMWgZlulDf4h/Ntu7kK5Qqa6c=
MIME-Version: 1.0
In-Reply-To: <4AD4351D.9090003@cn.fujitsu.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
	 <1255419540-5481-2-git-send-email-fweisbec@gmail.com>
	 <4AD4351D.9090003@cn.fujitsu.com>
Date: Tue, 13 Oct 2009 10:58:43 +0200
Message-ID: <c62985530910130158n6393a877q8fe990ecaa2ff3c@mail.gmail.com>
Subject: Re: [PATCH 1/3] ftrace: add kernel command line graph function 
	filtering
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Stefan Assmann <sassmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/13 Li Zefan <lizf@cn.fujitsu.com>:
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +static int __init set_graph_function(char *str)
>> +{
>> +     strncpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
>
> should use strlcpy().
>

Right, I'll fix, thanks.
