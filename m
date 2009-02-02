Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZBBOwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZBBOwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZBBOv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:51:58 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:41340 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZBBOv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QaYetJ+bJoGLSjO0foq26XnSQd0qe+2s3kHrTq0jJyTZAW0zCvkXL0R9rlYkQir6K/
         lrZVazxDH5SqdZRsw4RV29eykcgcA+RWPvZ5xleiJe2f9rgF05KCt6gVR/8Pu9ZVM7sS
         S7qWMfs4mj/hOlGJj6qd/9HSWCniPRc7Pr6XY=
MIME-Version: 1.0
In-Reply-To: <1233586140.5903.95.camel@desktop>
References: <20090127001708.GA4815@nowhere> <1233586140.5903.95.camel@desktop>
Date: Mon, 2 Feb 2009 15:51:45 +0100
Message-ID: <c62985530902020651j59f3e041u2c80b96914b04765@mail.gmail.com>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/2 Daniel Walker <dwalker@fifo99.com>:
> On Tue, 2009-01-27 at 01:17 +0100, Frederic Weisbecker wrote:
>
>> All of the workqueues with 0 work inserted do nothing.
>> For several reasons:
>>
>> _ Unneeded built drivers for my system that create workqueue(s) when they init
>> _ Services which need their own workqueue, for several reasons, but who receive
>>   very rare jobs (often never)
>> _ ...?
>>
>
> Some of the workqueues you have on your system can be removed just by
> tuning your kernel config. It's more desirable to be able to remove the
> whole unused feature since that's all unused memory beyond just
> thread ..
>
> Daniel


Yes of course. I just think about the distros which enable a lot of
options by default.
