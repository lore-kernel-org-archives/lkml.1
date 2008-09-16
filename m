Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYIPI2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYIPI2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYIPI2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:28:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:40363 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYIPI2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ivLwlB5N2EtUVltEDblhbxrEoLr3SSflRByxUxIwcJknwd9Jdu3o9tXKnhPKTtR9Gr
         HIRttiEt1R7fFgbXkJ6KMpxCodJmpYDTSPAFY/ptAw35m/w2MI5t3tSqwNE20DMopGqf
         Sqo/KqapWdKr/5u35xr1UDYjvWHVc9pQkQW98=
Message-ID: <3bedf6ab0809160128l101d44feh671dbeb4a8401360@mail.gmail.com>
Date: Tue, 16 Sep 2008 13:58:21 +0530
From: "karthikeyan S" <karthispeaks@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: A bug (probably) in stop_all_threads
Cc: "Grant Coady" <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080916062226.GA29225@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com>
	 <o44nc4dd8tpl94vf9bv81oklq8lt29112t@4ax.com>
	 <20080916051751.GA28475@1wt.eu>
	 <3bedf6ab0809152249r524cce0v1c14bfdff46aa12d@mail.gmail.com>
	 <20080916062226.GA29225@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 11:52 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Tue, Sep 16, 2008 at 11:19:58AM +0530, karthikeyan S wrote:
>> Hi Willy,
>>
>> Thanks for getting back. Yes, I tried to set the state to
>> TASK_INTERRUPTIBLE. It solves the issue. The other processes now get a
>> chance to handle the SIGSTOP sent to them.
>
> OK, that will help me review the current code and compare it with 2.6.
> If you could send me your patch, it will even save me more time. Based
> on your report, it's very likely that it will get merged.

Sure, I can definitely send the patch. I haven't sent a patch before,
and I am not fully aware of the process to follow. It might take a
little bit if time, but I will try to send it very soon.

-karthik
>
> Thanks,
> Willy
>
>
