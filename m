Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbZANAZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbZANAZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZANAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:25:31 -0500
Received: from mail.tmr.com ([64.65.253.246]:56642 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758276AbZANAZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:25:29 -0500
Message-ID: <496D30C3.4010905@tmr.com>
Date: Tue, 13 Jan 2009 19:24:35 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
References: <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com> <20090113115408.GA22289@ioremap.net> <20090113121510.68a55fe9@lxorguk.ukuu.org.uk> <20090113122904.GC25011@ioremap.net> <20090113131937.GB17664@mit.edu> <20090113133555.GA28107@ioremap.net>
In-Reply-To: <20090113133555.GA28107@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> So effectively oom_adj only works as enable/disable switch, and since no
> one knows how to tune it, it is better to do not touch at all. And get
> ssh killed. I believe if it is ever used then only to disable oom at
> all, which is wrong, since task still may be killed but after some
> others. My patch adds a simple priority for that based on the name of
> the process, which are known to the administrators who maintain given
> system.
>
>   
If nothing else, this would seem to reduce the number of processes for 
which the OOM coefficient of evil must be calculated.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


