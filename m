Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYKZADB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYKZADB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 19:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYKZACw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 19:02:52 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:57203 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYKZACw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 19:02:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S1NVlrFlTUtnq5XN87LUbmK73O3U3EPWvr64TceLcfU6XC0gQ4wtXk4N9AMpiQezBy
         tD4CmiWbG6KAb0JZTpOu38u6RUOxRf73cUw2OIxg9HkaM1Z2zvM5S+VkwOWtTySTWm9v
         1BszDNz3HePVI8pX8xvO5d/PPP36Pv5uKOrUg=
Message-ID: <c62985530811251602w4823d984wf744e75fe21b61af@mail.gmail.com>
Date: Wed, 26 Nov 2008 01:02:50 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081125223456.976670734@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125223421.795046329@goodmis.org>
	 <20081125223456.976670734@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Steven Rostedt <rostedt@goodmis.org>:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: feature to function trace a single thread
>
> This patch adds the ability to function trace a single thread.
> The file:
>
>  /debugfs/tracing/set_ftrace_pid


That's a good idea!

About the pid, I think they are unique (which is not the case for tgid
for multiple threads).
pid are tgid + number of the thread....

But perhaps I'm wrong....
