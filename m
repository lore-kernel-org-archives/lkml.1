Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYKRRA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYKRRA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYKRQ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:59:03 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:32198 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYKRQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:59:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JrnQThyEVSPusrM1yZ4rM+1wT3+5mmw+pKDdr5iLXXJIJyO1vEabd7ce9Yzvscniym
         U5RKYKBGYymrDHqD9l3ZtWn5mEHcIzcHxG14TmJIMCMQ/qaeO3OPWojEIlNN5G8UmCeR
         wymIaJUvcFrJRnxscY2fvNfpoqWfAcJdK01CM=
Message-ID: <c62985530811180858u397fbac8h63f61b6d816abb46@mail.gmail.com>
Date: Tue, 18 Nov 2008 17:58:59 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811181151010.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081117084923.GD28786@elte.hu> <20081118145154.GC30358@elte.hu>
	 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
	 <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
	 <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
	 <20081118164019.GA18620@elte.hu>
	 <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
	 <alpine.DEB.1.10.0811181151010.15003@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Steven Rostedt <rostedt@goodmis.org>:
> How about a compromise, start off the patch series getting it working with
> task struct static array, and then finish the series with the dynamic
> array.
>
> This is my development model, because it lets me know where the bugs are
> better. If we find some strange bug, this can help pin point via a bisect
> if the bug is with the general code, or with the use of a dynamic array.
>
> Just my preference ;-)


Ooh. I first agreed with Ingo's arguments about the fact that distros
can enable it whithout worrying.
But as I read your message, I guess that would be better to start with
static arrays to better find the bugs,
state by state...

Ingo, what do you think?
