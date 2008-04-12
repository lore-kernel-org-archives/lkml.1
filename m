Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYDLUU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYDLUU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYDLUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:20:12 -0400
Received: from main.gmane.org ([80.91.229.2]:33121 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbYDLUUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:20:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Date: Sat, 12 Apr 2008 20:19:55 +0000 (UTC)
Message-ID: <pan.2008.04.12.20.19.55@telenet.be>
References: <pan.2008.04.12.16.13.01@telenet.be>
	<20080412191914.GA6573@localhost.ift.unesp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 16:19:14 -0300, Carlos R. Mafra wrote:

> But in the log you uploaded you have only two se.wait_max greater than
> 40 msecs
> 
> [mafra@localhost:~]$ grep se.wait_max cfs-debug-info-2008.04.12-18.00.20
> |awk '{ {if ($3 > 40.000000) print $3} }' 44.153039
> 50.841370
> 
> As these numbers are only a bit greater than 40, I guess your problem is
> not related to the CFS scheduler.
> 
> Can you try latencytop? ( www.latencytop.org )

I'm not too sure how I should use latencytop and interpret its results. I 
start latencytop, and reproduce the problem while rhythmbox is playing. It 
seems that it automatically changes the selected application in the bottom 
list after a few seconds, probably based on the CPU usage, where it 
selects most of the time either compiz or X. The upper half of latencytop 
is always empty, for all applications. In the lower half, it shows for all 
applications something like:

Process X (7972)
Scheduler: waiting for cpu     43.5 msec         43.5 msec

Only the times differ between the different processes.

And that's all...

-- 
Frederik Himpe

