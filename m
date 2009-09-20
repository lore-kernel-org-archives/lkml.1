Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZITSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZITSar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbZITSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:60052 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZITSam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:42 -0400
Date: Sun, 20 Sep 2009 20:30:48 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Junhee Lee <junhee@netsys.kaist.ac.kr>, linux-kernel@vger.kernel.org
Subject: Re: microsecond event scheduling in an application
Message-ID: <20090920203048.7b1b5aa2@infradead.org>
In-Reply-To: <4AB673C1.7020909@gmail.com>
References: <015f01ca3090$85e8a280$91b9e780$@kaist.ac.kr>
	<4AB673C1.7020909@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
