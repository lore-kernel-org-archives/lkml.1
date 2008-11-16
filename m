Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYKPOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYKPOJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKPOJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:09:15 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:14196 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYKPOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:09:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hBnX92fyga5XfV0l0qiVOnQFw+fyepgmLOKwpL99TyPzmeyLfdJcdnkhPo637zPVaQ
         V6FXxbfzknuv2ww2PIiPMVGCqj/1tVg5k8Jcd27Uh93ShKK0JiyrLTls0L9qIxYpMdzi
         yqvg99NumqoYJo/CoXpuL+gSaIKx8PHjqjfR8=
Message-ID: <c62985530811160601j1f1fb09cy7a1ad63b373b85b3@mail.gmail.com>
Date: Sun, 16 Nov 2008 15:01:24 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/4] tracing/branch-tracer: Fix a trace recursion on branch tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jonathan Corbet" <corbet@lwn.net>
In-Reply-To: <20081116064948.GD32215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491FA8C8.1040905@gmail.com> <20081116062213.GA32215@elte.hu>
	 <c62985530811152232q2794ce1o6732c241821c6eca@mail.gmail.com>
	 <20081116064948.GD32215@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/16 Ingo Molnar <mingo@elte.hu>:
> Regarding the "Impact" line, it's cool that you started adding them.
> I'd like to ask you to tweak them a little bit in the future: please
> try to describe the "practical impact" via them - not just a
> repetition of the source code change that the patch does.
>
> For example, for this patch, instead of this impact-line:
>
>  Impact: Make the branch tracer use raw irq save/restore
>
> a better one is:
>
>  Impact: fix crash when enabling the branch-tracer
>
> (i changed it in this patch, no need to resubmit. And it's not well
> documented anyway.)
>
> Thanks,


Ok. Yeah I had some trouble with this "impact" tag, finding it hard to
not overlap its message with this of the patch's subject but I better
understand now...
Perhaps this tag should be explained in
Documentation/development-process/5.Posting and SubmittingPatches...
(cc-ed Jonathan for the development-process documents)....
