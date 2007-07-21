Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXGUQ3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXGUQ3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXGUQ3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:29:38 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:31754 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbXGUQ3h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:29:37 -0400
Date: Sat, 21 Jul 2007 17:29:29 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-ID: <20070721162929.GA13232@deepthought>
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com> <20070720175730.GB21550@deepthought> <46A2101D.5020400@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <46A2101D.5020400@tmr.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 09:54:37AM -0400, Bill Davidsen wrote:
> 
> So is setting it to a random number considered correct behavior? Any of 
> the first three values I mentioned would make sense, but the value I see 
> is neither time since resume, time since power-on to do the resume, or 
> any of the logical uptime values. That was the whole point of the 
> original post, the uptime reported makes no sense at all.
> 
 I assumed you had booted for a short time, suspended, resumed, and
then noticed the uptime was longer than time since resume.

 If you think there is a bug it might help to do a cold boot, at
some point note uptime and then immediately suspend, resume some time
later, immediately note uptime (including local time), keep it
running, and later monitor uptime against local time (i.e. the local
time will let you know the change you expect to see in uptime).  You
might also want to confirm that the local time is maintained
correctly.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
