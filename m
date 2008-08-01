Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbYHADDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbYHADDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYHADDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:03:35 -0400
Received: from main.gmane.org ([80.91.229.2]:50126 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbYHADDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:03:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: 2.6.27-rc1 process time accounting
Date: Fri, 1 Aug 2008 03:03:23 +0000 (UTC)
Message-ID: <loom.20080801T025718-689@post.gmane.org>
References: <20080731104319.GB5806@ics.muni.cz> <20080731144147.82fcd85e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.208.232.147 (Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.1) Gecko/2008070206 Firefox/3.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm <at> linux-foundation.org> writes:

> 
> On Thu, 31 Jul 2008 12:43:19 +0200
> Lukas Hejtmanek <xhejtman <at> ics.muni.cz> wrote:
> 
> > Hello,
> > 
> > I think there is a regression since 2.6.26 in time accounting of processes.
> 
> Could be - we changed quite a bit.
> 
> > kthreadd and console-kit-daemons claim they spent 5124095 hours using CPU.
> 
> My 2.6.27-rc1-mm1 kthreadd looks OK in `top'.  How are you displaying
> this information?  More details if possible, please..
> 

Top's doing crazy things on my machine too after booting 2.6.27-rc1 - like Xorg
showing 859% CPU usage on 4 CPU machine and generally any process running even
shortly shows up as using anywhere between 100 and 150% CPU.

This is on x86 - Q6600 6Gb RAM. Let me know if anything else would be
interesting to know.

Parag


