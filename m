Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbXK0PUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbXK0PUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXK0PUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:20:31 -0500
Received: from ginger.cmf.nrl.navy.mil ([134.207.10.161]:63422 "EHLO
	ginger.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXK0PUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:20:30 -0500
X-Greylist: delayed 2348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 10:20:30 EST
Message-Id: <200711271440.lAREedEK011753@cmf.nrl.navy.mil>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Joonwoo Park <joonwpark81@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Reply-To: chas3@users.sourceforge.net
Reply-To: chas3@users.sourceforge.net
Subject: Re: [PATCH 4/4] atm/ambassador: kmalloc + memset conversion to kzalloc 
In-reply-to: <alpine.LFD.0.9999.0711260619580.10766@localhost.localdomain> 
Date: Tue, 27 Nov 2007 09:40:39 -0500
From: "chas williams - CONTRACTOR" <chas@cmf.nrl.navy.mil>
X-Spam-Score: () hits=-1.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <alpine.LFD.0.9999.0711260619580.10766@localhost.localdomain>,"Rober
t P. J. Day" writes:
>> > in any event, i just thought i'd point it out.  if you're absolutely
>> > sure there will never be another call to setup_dev() from somewhere
>> > else, then, yes, it's safe.
>>
>> I understood your opinions. and partially agree with you.
>> But isn't it a unfounded fear?
>
>i don't know, i just thought i'd mention it.  if no one thinks it's an
>issue, it's certainly fine with me.

its very unlikely that setup_dev() is likely to be called from another
code path.  this patch looks fine to me.  i will take it and get it
submitted on the next merge.
