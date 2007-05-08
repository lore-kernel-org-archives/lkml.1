Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXEHGHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXEHGHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXEHGG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:06:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbXEHGG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:06:56 -0400
Message-ID: <4640137A.8030000@zytor.com>
Date: Mon, 07 May 2007 23:06:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com> <200705072237.33217.a1426z@gawab.com> <463F80E3.8020204@zytor.com> <200705072356.51283.a1426z@gawab.com>
In-Reply-To: <200705072356.51283.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> 
>> What you're talking about is, *and should be*, a different filesystem.
>> You will relatively quickly find that you have to deal with the same
>> kind of stuff that you have to in any filesystem.
> 
> That's exactly what I want to avoid, as this would introduce a performance 
> penalty.
> 
> All we need is a periodically synced tmpfs to mmap, with a minimal stream 
> into page-cache algo on mount.
> 

... which would be completely useless, because you wouldn't get any sort
of coherency; you would have pointers pointing into space, etc. etc.

Sorry, it's useless.

	-hpa
