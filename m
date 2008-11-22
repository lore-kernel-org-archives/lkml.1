Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYKVWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYKVWVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYKVWVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:21:36 -0500
Received: from mx.treblig.org ([80.68.94.177]:43843 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYKVWVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:21:35 -0500
Date: Sat, 22 Nov 2008 22:21:21 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Question regarding SAS controllers.
Message-ID: <20081122222120.GA12360@gallifrey>
References: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com> <alpine.DEB.1.10.0811221658280.707@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811221658280.707@p34.internal.lan>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.23.1-bytemark-uml (i686)
X-Uptime: 22:19:09 up 48 days,  4:14,  2 users,  load average: 0.07, 0.03, 0.02
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Justin Piszcz (jpiszcz@lucidpixels.com) wrote:

<snip>

> Eric,
> 
> Thanks, I had checked this out earlier but the only non-raid SAS HBAs 
> (those HBAs that do not end in -R) that are JBOD seem to be external only
> (e.g., do not contain any internal SAS ports?)
> 
> Justin.

For some of the SAS cards that LSI produce there are 2 sets of firmware
on their site and you can load the non-RAID firmware; both versions
will let you drive stuff as individual drives (e.g. tape drives or
inidivudal discs) but the non-RAID firmware is a LOT faster for that.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
