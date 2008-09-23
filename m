Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYIWS2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYIWS2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYIWS2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:28:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22046 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754821AbYIWS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:28:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=mlABwCE06bfG6deqJtLCvHI1zoaWpteaWWmbfUBZj/uJvS7381ruAXsc4WEOZEjj/
	ZXJzkjEeG/HwYIl1izwQg==
Message-ID: <33307c790809231128w44c79b8y40a821c2989f9b73@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:28:17 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Unified tracing buffer
Cc: "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <20080924025457.DC24.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48D90970.3060409@redhat.com>
	 <20080924025457.DC24.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-GMailtapped-By: 172.25.146.77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think the main reason of using single-channel mode is simplicity of
>> userspace reader. We can use 'cat' or 'tail' to read the buffer on-line.
>> I'm not sure how much overhead ftrace-like buffer merging routine has,
>> but if kernel provides an interface which gives us single-merged buffer
>> image(like ftrace buffer), we are grad to use it. :-)
>
> Yup, I also think it is better.

That was the plan, yes. Merge sort is cheap ;-)
