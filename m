Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606Ab0AMGRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab0AMGRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329Ab0AMGRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:17:12 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:40969 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab0AMGRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:17:11 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Date: Wed, 13 Jan 2010 08:16:43 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc3; KDE/4.2.4; x86_64; ; )
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
References: <201001122242.22774.mitov@issp.bas.bg> <20100112235221.GA20761@aao.gov.au> <20100113001724.GB29904@kroah.com>
In-Reply-To: <20100113001724.GB29904@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001130816.43855.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 02:17:24 am Greg KH wrote:
> On Wed, Jan 13, 2010 at 10:52:21AM +1100, Scott Smedley wrote:
> > Hi Marin,
> > 
> > > dt3155 frame grabber I am using in my experiments since 
> > > the time of 2.6.17 kernel.
> > 
> > Whoah!
> > 
> > > I will really appreciate your comments, suggestions, criticism.
> > 
> > I haven't tried your driver but the code looks much neater than
> > our driver. Still, I am wondering why you chose to implement a
> > device driver from scratch, rather than use an existing one?
> > 
> > http://sourceforge.net/projects/dt3155a/

In fact I used this one before switching to 2.6.17 kernel (see 

http://lfb.issp.bas.bg/~mitov/linux/dt3155pci/00README

for details) and it was working well for single image acquisition.
(except for the problems with having too much HIGHMEM).
For real time acquisition (25 frames per sec), display and write
on HDD I needed heavy buffering, otherwise frames are skipped.

Another minor reason was I had already written an OS2 driver 
for the same hardware and liked to try the same on linux :-).

Scott, 

if you have 2 or more boards, could you check if
my driver is working with more than one board? I have only one
and cannot do this check. I could send you a multi-threaded
program for the test if you need it.

Marin Mitov

> > 
> > I'll leave decisions about whether to merge or discard (either
> > driver) to Greg. My 2 cents is that there should only be 1 DT3155
> > driver for users to choose from.
> 
> I agree, we only need one of them.
> 
> Scott, any comparison between the two of them as to which one actually
> works better?
> 
> thanks,
> 
> greg k-h
> 
