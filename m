Return-Path: <linux-kernel-owner+w=401wt.eu-S1764612AbYCGP2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764612AbYCGP2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYCGP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:28:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54488 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753265AbYCGP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:28:43 -0500
Message-ID: <47D15F18.9020600@atmel.com>
Date: Fri, 07 Mar 2008 16:28:24 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, hans-christian.egtvedt@atmel.com,
       hskinnemoen@atmel.com, avictor.za@gmail.com
Subject: Re: [PATCH] at73c213: Monaural support
References: <20080307.190234.55730878.nemoto@toshiba-tops.co.jp>	<47D13185.4080803@atmel.com> <20080308.002557.51867582.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080308.002557.51867582.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsushi Nemoto wrote:
> On Fri, 07 Mar 2008 13:13:57 +0100, Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:

>> Although, I had to use 32 * 1024 buffer_bytes_max and 16 * 1024
>> period_bytes_max. Higher buffer_bytes_max resulted in glitching sound
>> when only using one channel. Nothing to do with this patch.
> 
> Hmm, it sounds strange.  But I still do not understand sound buffer
> management well...
> 

Me neither, alsa is a bit big and tons of layer hiding where stuff is 
actually done. Still unsure what to do about the buffer and period size, 
but I think setting them to 32k and 16k will work for most people.

-- 
HC, which just got a new email address
