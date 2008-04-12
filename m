Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYDLSGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYDLSGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYDLSGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:06:46 -0400
Received: from main.gmane.org ([80.91.229.2]:56378 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbYDLSGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:06:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Date: Sat, 12 Apr 2008 18:06:24 +0000 (UTC)
Message-ID: <pan.2008.04.12.18.06.24@telenet.be>
References: <pan.2008.04.12.16.13.01@telenet.be>
	<20080412175124.GA4551@gentoox2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008 19:51:24 +0200, Markus Trippelsdorf wrote:

> On Sat, Apr 12, 2008 at 04:13:01PM +0000, Frederik Himpe wrote:
>> I'm experiencing a lot of problems with audio skipping on my system. I
>> am using Rhythmbox as an audio player and have Compiz active. Whenever
>> I maximise or restore a maximised real transparent gnome-terminal,
>> audio skips. Compared to other normal applications, restoring the
>> transparent console is also slow (it takes a few seconds before the
>> window appears). ...
>> This problem happens with both 2.6.24.4 as with 2.6.25-rc9 (the
>> debugging information is from the latter version).
>> 
>> 
> Try to disable the group scheduler in your kernel configuration. It
> solved the audio skipping problem on my machine...

I think I have it disabled already?

$ zcat /proc/config.gz | grep GROUP
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set

Or am I missing something?

-- 
Frederik Himpe


