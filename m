Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXEOWt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXEOWt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXEOWtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:49:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:30729 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbXEOWtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dgIe07OdLJco7ZZANBkXK/Pd/Vg9TD+1j02wRbsdhPvPye5vGqbFlUjqeHzvShRwBYJs8jPXb2hxYiuhUsibDM5weA6ZTvYuOaEq4p7GAYCwbSS0MqmPYc7FATbfepQbqqKULr4RVMRE7P6L+R4vaswICbzVF0/aR1SnWYc6+Jw=
Message-ID: <a2ebde260705151549r2762ac1fk9a68db7b903e6525@mail.gmail.com>
Date: Wed, 16 May 2007 06:49:16 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "pradeep singh" <2500.pradeep@gmail.com>,
       "Bahadir Balban" <bahadir.balban@gmail.com>,
       "Learning Linux" <learninglinux4@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4649E680.9020102@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
	 <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
	 <4649E680.9020102@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/16, Phillip Susi <psusi@cfl.rr.com>:
> Dong Feng wrote:
> >> Doesn't it run in current process's context ?
> >>
> >
> > No. I think the concept of process context is a higher-level logical
> > concept. Though the interrupt share stack with the interrupted
> > process, in my opinion it logically does not share the context with
> > the process.
>
> No, the term context here has a specific meaning.  It refers to those
> things which flow from the current pointer, including the virtual memory
> space, file descriptor table, current uid, and so forth.  Because the
> current pointer is not changed on entry to an ISR, the ISR is executing
> in the context of the interrupted process, and thus uses that process'
> virtual memory, etc.
>

If what you say were true, then an ISR would be running in the same
context as the interrupted process. But please check any article or
book, it will say ISR running in different context from any process.
So ISR is considered in its own context, although it shares a lot of
things with the interrupted process. I would only say *context* is a
higher-level logical concept.
