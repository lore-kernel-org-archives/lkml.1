Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLXDDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLXDDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYLXDDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:03:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:54908 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLXDDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MJzAGqdqA+aJO5WgQgCyLYLV/DtCjBA94vJ8pFKkucpUrDYyz4qP5IvesOXex3sbm+
         JOBTgiK6chEqINfeIE141HqAMSVsbW1k6osY1OnOQxq8slvfAgc6D0DzLkx+Fe4l8igt
         ZI8e+v5gfdQXxO99bt+6p+iZl3bFJJWNUN5Ps=
Message-ID: <c62985530812231903q59f1e1y4523b3e37b7f9b34@mail.gmail.com>
Date: Wed, 24 Dec 2008 04:03:04 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of secondary cpu boot
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530812231857l17362f94k271b66abbe7d7099@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <49518535.8080105@gmail.com>
	 <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com>
	 <c62985530812231857l17362f94k271b66abbe7d7099@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/24 Frédéric Weisbecker <fweisbec@gmail.com>:
> One other solution, would be to define raw_smp_processor_id() to
> stack_smp_processor_id() and current to
> cpu_pda(stack_smp_processor_id()) if function_tracer is configured.


Sorry, I meant cpu_pda(stack_smp_processor_id())->pcurrent
