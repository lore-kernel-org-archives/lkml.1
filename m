Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbZABQE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbZABQE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZABQEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:04:16 -0500
Received: from co203.xi-lite.net ([149.6.83.203]:39212 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869AbZABQEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:04:15 -0500
Message-ID: <495E3AF8.6000006@parrot.com>
Date: Fri, 02 Jan 2009 17:04:08 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <200901020513.19593.rob@landley.net>
In-Reply-To: <200901020513.19593.rob@landley.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2009 16:05:09.0585 (UTC) FILETIME=[E2DE6C10:01C96CF3]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley a écrit :
> On Friday 02 January 2009 03:26:37 Arkadiusz Miskiewicz wrote:
>> On Friday 02 of January 2009, Rob Landley wrote:
>>
>> Heh,
> 
> I believe all three scripts run under dash and busybox ash.  (The timeconst.sh 
> one needs 64 bit math which dash only provides on 64 bit hosts, which is a 
> regression from Red Hat 9 in 2003 by the way.
With dash 0.5.4-12 (from debian sid), I seems I got the 64 bit math for
32 bit hosts :
$ uname -m
i686
$ dash -c 'echo $((1<<32))'
4294967296


Matthieu
