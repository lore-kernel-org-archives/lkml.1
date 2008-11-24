Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYKXUaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYKXUaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYKXUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:30:26 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:40787 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYKXUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:30:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CjpVsN3LfetLoMo9dB3HaMbFP5oIOZR9EmSM5iEofYmRmrkWh5SetLy355LDV5NAJG
         /YRWukp55BN1MlPeW8VzrKc9HBUH9AlOtAcHCf4SWiI81N3HSxHD6aLts1u9v0EBPwq1
         hslu1T7AQKcskOFL70ZAcgUVTI5LJsSMe1ywI=
Message-ID: <c62985530811241230x601a27e1w504b0564b9513a13@mail.gmail.com>
Date: Mon, 24 Nov 2008 21:30:24 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081124221849.33c91bcf@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	 <alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	 <20081123212430.4f6700e9@daedalus.pq.iki.fi>
	 <20081123193413.GB2794@elte.hu>
	 <20081124221849.33c91bcf@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Pekka Paalanen <pq@iki.fi>:
> On Sun, 23 Nov 2008 20:34:13 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> Sure - applied them to tip/tracing/urgent:
>>
>>   fb91ee6: tracing, doc: update mmiotrace documentation
>>   7ee1768: x86, mmiotrace: fix buffer overrun detection
>>
>> Does this make mmiotrace fully functional in .28 ?
>
> Oh right, the busylooping bug when echoing into trace_marker,
> I already forgot about that, since I couldn't reproduce it.
> I guess there's nothing to do, until someone finds a way to
> reproduce it.


Hi Pekka.

Are you talking about this old bug that broke the pipe?
If so, you fixed it yourself partially with a patch that corrected
tracing_read_pipe.
Another origin was the none tracer that set tracer_enabled to 0.
But i has been fixed with the nop tracer.

Perhaps you are talking of something else?
