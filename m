Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYK0NLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYK0NLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYK0NLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:11:08 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:50380 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYK0NLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s2FQj8W1GQUKe1LYrOSXDpymKddzFk/tuAMnKPacBZOFngAc0geKFifT6u13hJqplC
         f9Znymj9M5dUMTgPNJAyaa7eaYR82RuAqJiAuJjw0xCgWV0+nd6rGg6bX0hr++YqCUyW
         UoEjAGzVpkNhriRNOi2HU+aBF6NIBdmDDplvw=
Message-ID: <c62985530811270511q2a3d86bcye4f90486624312e2@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:11:05 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1227783300.4454.1410.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <1227783300.4454.1410.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Thu, 2008-11-27 at 11:34 +0100, Ingo Molnar wrote:
>> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> > Here is an example of the new output:
>> >
>
>> > CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------
>
> This is the most horrid thing I've ever seen.
>
> Please just put the comm/pid in another left column and leave a plain
> "---" string for context switches.
>
> comm/pid only in the separator is useless, you cannot grep stuff like
> that, also, what's up with those '8's ?


You don't like my ungreppable but cute scissors? :-)
Yes, I will fix it.
