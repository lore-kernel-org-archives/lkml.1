Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZKLPTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZKLPTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZKLPTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:19:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZKLPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:19:04 -0500
Message-ID: <4AFC274C.2020209@zytor.com>
Date: Thu, 12 Nov 2009 07:18:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com> <20091112065930.GA9279@elte.hu> <4AFBB45A.9000606@zytor.com> <20091112081317.GB25345@elte.hu>
In-Reply-To: <20091112081317.GB25345@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 12:13 AM, Ingo Molnar wrote:
>>
>> /proc/cpuinfo is a user-space visible ABI.  Changing it is bad 
>> chicken.
> 
> Almost ... something is only an ABI if an actual application relies on 
> the 'ht' flag being there on non-hyperthreading CPUs. We dont know 
> whether there's any, but the likelyhood looks pretty low. Could park it 
> a branch for some time to see whether anything trips up.
> 

No, please.  We have had people who have "helpfully" tried to change
/proc/cpuinfo in the past, and what we find is that application
developers don't tell us -- they grumble among themselves and put out a
new release saying "fixes breakage introduced by Linux ..."

It's an ABI.  Keep it stable, please.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

