Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYISLbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYISLbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYISLaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:30:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYISLaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k+8dBR+e5NpBkB0gcmuCex4cBpM4XlVqijtlTS86xljfoLpkvZo2l8uv8nGcgVFY5x
         GhMURS7JoxehaeQzPSbJtf4KgxirvuTKB6WBYKrm1kkHAtTJ34j0lS/gRxP9CyFunHIJ
         qXPoP99KWUi7cxYZ6laoHACBc8XHbQKEeVz+w=
Message-ID: <c62985530809190430sbdfd4c2l55348653459b7250@mail.gmail.com>
Date: Fri, 19 Sep 2008 13:30:53 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Cc: "Steven Noonan" <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080919110449.GB30624@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
	 <c62985530809190348h3a74de3aqd0ca2e893b11bb8c@mail.gmail.com>
	 <20080919110449.GB30624@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/19 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> It seems we have two "none" tracers now. Why not seeing this nop
>> tracer as an improvment of the current "none tracer" ?
>>
>> As a result the none tracer contained in trace.c could be replaced by
>> this new one as the default tracer. And that's said, that will enable
>> trace_printk by default even when no tracer is selected by the user.
>>
>> What do you think about it?
>
> hmm ... good idea. There are some special properties of the none tracer
> (it inhibits trace output for example), and those should be discontinued
> i guess.
>
>        Ingo
>

Ok. I will prepare a patch to submit this idea.
