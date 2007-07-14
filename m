Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbXGNKtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbXGNKtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760849AbXGNKtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:49:32 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:18617 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760015AbXGNKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MGq3Fw0OeU3/0b6qk2T2kIs3xclYtLlDeCGkSt+Pf1tkIhMZx37sp5Nb+vSwF4yMXhhM4CI527XgJ7MZE+JRug1HLYEfQl1ZqhNOcP+xsVTLYcp/w0zJA9cSp0u2Zt59HiqXXdh135zCy5k/LT6bUmK/pEl3AXelUCYgrU7zHgc=
Message-ID: <6d4bc9fc0707140349y1874dc1ag75075c84137c4d6d@mail.gmail.com>
Date: Sat, 14 Jul 2007 12:49:29 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [realtime-preempt] [x86_64] HR_TIMER and/or DYNTICKS cause an early boot freeze
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1184337551.20032.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d4bc9fc0707130702l41f58c20l72423be27292d884@mail.gmail.com>
	 <1184337551.20032.89.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Were can -rt3 be found?

On 7/13/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2007-07-13 at 16:02 +0200, Maarten Maathuis wrote:
> > I have determined that version 2.6.22.1-rt2 freeze after:
> >
> > NET: Register protocol family 2
> >
> > This is very early in the boot stage, and i cannot determine what
> > exactly causes it.
> >
> > It happens if either high resolution timers or dynamic ticks are active.
> >
> > I have included the config file that does work (so dynticks and
> > hr_timers are disabled).
> >
> > Please CC any replies, as i am not a member of this mailinglist.
>
> Try -rt3, that solved this issue for me.
>
>
