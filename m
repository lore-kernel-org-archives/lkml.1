Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZIVGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZIVGfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZIVGfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:35:30 -0400
Received: from netsys.kaist.ac.kr ([143.248.239.50]:37179 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZIVGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:35:30 -0400
From: "Junhee Lee" <junhee@netsys.kaist.ac.kr>
To: "'Arjan van de Ven'" <arjan@infradead.org>,
       "'Robert Hancock'" <hancockrwd@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <015f01ca3090$85e8a280$91b9e780$@kaist.ac.kr>	<4AB673C1.7020909@gmail.com> <20090920203048.7b1b5aa2@infradead.org>
In-Reply-To: <20090920203048.7b1b5aa2@infradead.org>
Subject: RE: microsecond event scheduling in an application
Date: Tue, 22 Sep 2009 15:35:09 +0900
Message-ID: <005601ca3b4e$d5361660$7fa24320$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco6IC18ABCMcwY4S8q7GNjooAfm3gBLkaCQ
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Arjan van de Ven. 
Your comment is very useful to me.
Now I am trying to solve microsecond events scheduling using hrtimer.

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Monday, September 21, 2009 3:31 AM
To: Robert Hancock
Cc: Junhee Lee; linux-kernel@vger.kernel.org
Subject: Re: microsecond event scheduling in an application

On Sun, 20 Sep 2009 12:26:09 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On 09/08/2009 08:27 AM, Junhee Lee wrote:
> > I am working on event scheduler which handles events in microsecond
> > level. Actual this program is a network emulator using simulation
> > codes. I'd like to expect that network emulator is working as
> > simulation behaviors. Thus high resolution timer interrupt is
> > required. But high resolution timer interrupt derived by high tick
> > frequency (jiffies clock) must effect the system performance.
> > Are there any comments or ways to support microsecond event
> > scheduling without performance degradation?
> 
> Just increasing HZ will degrade performance, yes, but we have
> hrtimers now which should be able to use granularities smaller than
> one jiffy, so it shouldn't be needed..


select/poll use hrtimers, which are jiffies independent....

you'll be hard pressed to notice jiffies granularity in userspace
nowadays..



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

