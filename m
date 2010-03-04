Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0CDEGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:06:47 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56005 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0CDEGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bFdi72akGGDEdJV9ifu7JSgmauKho6GQr2r7yf0TF5Q4A9VXscAVpO5u6Jf9OQ+HXZ
         cFy/yrC0LZKzFyHwShKxWsMf09fr7Z5zUFsw8WchxaEgA3VGshb73sRUAVqQ3BoiwTpk
         HRx1zWtfrvPhVHwd098fWh8NNlgJ6ibxeDwJw=
Date: Thu, 4 Mar 2010 05:06:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.33: ftrace triggers soft lockup
Message-ID: <20100304040640.GB14460@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com> <20100304014641.GH5194@nowhere> <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com> <1267672706.10871.97.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267672706.10871.97.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 10:18:26PM -0500, Steven Rostedt wrote:
> On Thu, 2010-03-04 at 11:01 +0800, Américo Wang wrote:
> 
> > >
> > > So it is stuck in stop machine. I wonder where exactly. I see some do_exit
> > > at the top but I wonder how much they are reliable.
> > 
> > Well, I think 'kstop' is just random, sometimes I got 'watchdog' or some other
> > process.
> > 
> > >
> > > Anyway, as Steve said, we really need a full config to reproduce it.
> > >
> > 
> > Done in another reply.
> 
> Thanks!
> 
> Frederic, I notice that lockdep is on, did anything change that might
> slow down the code in lockdep, or is the function graph tracer doing
> more locking?


No,
there doesn't seem to be intrusive changes in lockdep between .32 and .33
And the function graph tracer is still fully lockless (and hopefully
it will be forever).

