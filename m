Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799Ab0ARBGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0ARBGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683Ab0ARBGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:06:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0ARBGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:06:51 -0500
Message-ID: <4B53B218.6000607@zytor.com>
Date: Sun, 17 Jan 2010 16:58:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, jaswinder@kernel.org,
       stable@kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4EC0A1.3090503@pardus.org.tr> <4B4ECB1C.6070000@kernel.org> <4B4EF35D.3040203@pardus.org.tr> <4B4F1764.2040406@pardus.org.tr> <4B4F1DE7.307@pardus.org.tr> <4B51B0E8.1010302@pardus.org.tr>
In-Reply-To: <4B51B0E8.1010302@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 04:28 AM, Ozan Çağlayan wrote:
> 
> Linux 2.6.31 is released on Sep 9th. So people having an Athlon XP processor + a kernel newer than 4 months
> which enables CONFIG_X86_CPU_DEBUG can't even boot into a linux kernel. I was *at least* expecting a comment from the relevant
> people but nope for 2 days.
> 
> It seems to be a serious regression which doesn't get caught. I'm also CC'ing Rafael, maybe he can inject this
> in one of his regression threads.
> 

Anything which involves enabling CONFIG_X86_CPU_DEBUG can hardly be
considered serious.  It's a broken piece of work that should never have
gotten into the kernel in the first place.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

