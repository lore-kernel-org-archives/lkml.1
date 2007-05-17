Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbXEQLjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbXEQLjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXEQLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:39:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:50102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbXEQLji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:39:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [PATCH] LogFS take three
Date: Thu, 17 May 2007 13:39:15 +0200
User-Agent: KMail/1.9.6
Cc: John Stoffel <john@stoffel.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       akpm@osdl.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org>
In-Reply-To: <20070515191926.GB1220@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705171339.16806.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++bYoXzM/V7OY7dCNTkqJbADI1RmVN+fouEBU
 pYBmdwHtQjy9YLIE3zTZEX0lw6pqc0A+JSVrjLutXLRz2fPPBv
 tB1vKQ+cSe3AaDCBwYAow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007, Jörn Engel wrote:
> 
> > I've been semi watching this, and the only comment I really can give
> > is that I hate the name.  To me, logfs implies a filesystem for
> > logging purposes, not for Flash hardware with wear leveling issues to
> > be taken into account.
> 
> Yeah, well, ...
> 
> Two years ago when I started all this, I was looking for a good name.
> All I could come up with sounded stupid, so I picked "LogFS" as a code
> name.  As soon as I find a better name, the code name should get
> replaced.
> 

When doing a google search on logfs, there are less than five results
among the first 100 that don't refer to your work. The other two listed
in there are also log-structured file systems: The inferno flash file
system (http://inferno-os.googlecode.com/svn/trunk/liblogfs/) and the
(discontinued) file system named lfs from the 2005 google summer of
code.

I'd say the name should stay, changing it now can only add more confusion.

	Arnd <><
