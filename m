Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXDWXrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXDWXrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXDWXrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:47:52 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:52795 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXDWXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:47:51 -0400
From: Ed Tomlinson <edt@aei.ca>
To: davidsen@posidon.tmr.com
Subject: Re: [REPORT] First "glitch1" results, 2.6.21-rc7-git6-CFSv5 + SD 0.46
Date: Mon, 23 Apr 2007 19:49:05 -0400
User-Agent: KMail/1.9.5
Cc: "Kolivas, Con" <kernel@kolivas.org>, "Molnar, Ingo" <mingo@elte.hu>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <462D2BDD.4040406@tmr.com> <200704231945.25613.edt@aei.ca>
In-Reply-To: <200704231945.25613.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231949.06108.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007 19:45, Ed Tomlinson wrote:
> On Monday 23 April 2007 17:57, Bill Davidsen wrote:
> > I am not sure a binary attachment will go thru, I will move to the web 
> > ste if not.
> 
> I did a quick try of this script here.
> 
> With SD 0.46 with X at nice 0 I was getting 1-2 frames per second.  I decided to try cfs v5.
> The option disable auto renicing did not work so many threads other than X are now at -19...
> 
> SD 0.46		1-2 FPS
> cfs v5 nice -19	219-233 FPS
> cfs v5 nice 0 	1000-1996
   cfs v5 nice -10  60-65 FPS
> 
> Looks like, in this case, nice -19 for X is NOT a good idea.
> 
> Kernel is 2.6.20.7 (gentoo) UP amd64 with HZ 300 voluntary prempt (a fully premptable kernel eventually 
> locks up switching between 32 and 64 apps)

Thanks
Ed 
