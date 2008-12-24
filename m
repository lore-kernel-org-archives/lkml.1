Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYLXDvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYLXDvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYLXDvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:51:07 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:62316 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLXDvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C4tal9Mswdioyjk0wY5PATtm4KtZUtQEcC5G5lovyrCfIXoqRouDv1X+J4eqmeeLlf
         xz/tHtxO7URVn5RtQy4ZqfVSJS9NcRTk8oPl317Mwbz1WlvI6kmSj+WkMhgbE/N4ABPP
         HYmE1hiaU078vLs8a0sFIZHTar5bnlAlC9RLg=
Message-ID: <c62985530812231951p4a943007j6d4a8632ee241921@mail.gmail.com>
Date: Wed, 24 Dec 2008 04:51:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of secondary cpu boot
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812232231140.21172@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49518535.8080105@gmail.com>
	 <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com>
	 <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
	 <alpine.DEB.1.10.0812232231140.21172@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/24 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 24 Dec 2008, Fr?d?ric Weisbecker wrote:
>>
>>
>> I first thought about annotate those first functions with "notrace".
>> But the code inside
>> cpu_init/pda_init could change later and call external/traced function.
>
> We could also hit it with the CFLAGS_REMOVE_common.o = -pg hammer.
> Those functions will not change much, and I doubt they will call other
> functions for the same reason that we can not call them. A simple
> preempt_disable here will crash the box.
>
> -- Steve

Ok, I will try with this solution.

Thanks.
