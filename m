Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYI0MSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYI0MSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 08:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYI0MRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 08:17:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:30051 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbYI0MRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 08:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rUrUCWoyEOuXBWG3DVflSvssPv+BQIiYS+JCf6+cPelPvxlXnI8EUkIZXWpC6ux8r/
         6jw1Ckvcmj5Hjyj6rZ0Qi/3zmqoyJ7Jrgk/yPfA7foOg2GpwtRDY6VZbXDj3FB+b4++r
         js3kbjd+IAi7FjdAbnHqkFFEmMhOfhTk66pu8=
Message-ID: <c62985530809270517g179f1d21nca05cf50b289b2f5@mail.gmail.com>
Date: Sat, 27 Sep 2008 14:17:47 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new type of print_line
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080927002121.0038cdfe@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DD0347.5070008@gmail.com>
	 <20080927002121.0038cdfe@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/26 Pekka Paalanen <pq@iki.fi>:
> On Fri, 26 Sep 2008 17:44:07 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Adapt mmiotrace to the new print_line type.
>> By default, it refuses types it doesn't support.
>> But a tracer needs to print something to the seq anyway.
>> That's why it needs to warn about unsupported types.
>>
>> Pekka if you disagree with it, please don't hesitate to tell me.
>
> Yes, I do disagree about printing stuff that doesn't belong there.
> First, I doubt printing bogus text is a right way to fix the
> early pipe EOF problem. Second, if you really have to do that,
> do it so that it obeys the mmiotrace log format specification.
> (I'd recommend a MARK entry.) The spec is in
> Documentation/tracers/mmiotrace.txt.
>
> This is just a very quick comment, and I should look at your two
> patches better. I hope to do that during the weekend.
>
> Was there supposed to be a third patch, as the subject suggests?
>
> Thanks.
>
>


No problem, I have one other option: ignoring and sleep again before
receiving another entries.
I can do another patch this week end to implement that.
The third patch only concerns the boot tracer. It relays to other
output functions.

Just tell me if you agree with the ignoring...

Thanks !
