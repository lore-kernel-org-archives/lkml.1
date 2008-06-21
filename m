Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYFUSji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYFUSji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYFUSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:39:31 -0400
Received: from nn7.de ([85.214.94.156]:60727 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbYFUSja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:39:30 -0400
Subject: Re: hdparm -M acoustic management for sata disks?
From: Soeren Sonnenburg <kernel@nn7.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <485D33A8.60200@rtr.ca>
References: <1214043295.17302.16.camel@localhost>  <485D098E.3080109@rtr.ca>
	 <1214066456.18959.6.camel@localhost> <485D3260.20301@rtr.ca>
	 <485D33A8.60200@rtr.ca>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Jun 2008 20:39:21 +0200
Message-Id: <1214073561.18959.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 13:00 -0400, Mark Lord wrote:
> Mark Lord wrote:
> >..
> > Here's hdparm-8.9 on a drive that *does* support the feature:
> > 
> > 
> > $ hdparm -I /dev/sda | grep Acoustic
> >           *    Automatic Acoustic Management feature set
> > 
> > $ hdparm -M /dev/sda
> > 
> > /dev/sda:
> > acoustic      = 254 (128=quiet ... 254=fast)
> > 
> > $ hdparm -M128 /dev/sda
> > 
> > /dev/sda:
> > setting acoustic management to 128
> > acoustic      = 128 (128=quiet ... 254=fast)
> > 
> > $ hdparm -M254 /dev/sda
> > 
> > /dev/sda:
> > setting acoustic management to 254
> > acoustic      = 254 (128=quiet ... 254=fast)
> ..
> 
> And one more:
> 
> $ hdparm -M0 /dev/sda
> 
> /dev/sda:
>  setting acoustic management to 0
>  acoustic      = 254 (128=quiet ... 254=fast)
> 
> $ hdparm -I /dev/sda | grep -i acoustic
>         Recommended acoustic management value: 128, current value: 254
>                 Automatic Acoustic Management feature set
> 
> (the lack of a '*' on that last line indicates the feature is no longer enabled).

OK, I guess I have to accept that the drives I have here just don't
support AAM - just couldn't imagine that rather new 750G drives etc
don't have that feature :( 

Thanks for the clarifications,
Soeren
