Return-Path: <linux-kernel-owner+w=401wt.eu-S934457AbXHNWxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457AbXHNWxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXHNWx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:53:27 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:4971 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbXHNWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:53:26 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46C233CB.9000602@am.sony.com>
Date: Tue, 14 Aug 2007 15:59:23 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: kfree(0) - ok?
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2007 22:53:21.0264 (UTC) FILETIME=[E99CCF00:01C7DEC5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a quick question.

I'm trying to resurrect a patch from the Linux-tiny patch suite,
to do accounting of kmalloc memory allocations.  In testing it
with Linux 2.6.22, I've found a large number of kfrees of
NULL pointers.

Is this considered OK?  Or should I examine the offenders
to see if something is coded badly?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

