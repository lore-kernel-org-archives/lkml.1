Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYJECHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYJECHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 22:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYJECGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 22:06:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYJECGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 22:06:52 -0400
Message-ID: <48E8209F.3010204@zytor.com>
Date: Sat, 04 Oct 2008 19:04:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in
 var mtrrs
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>	 <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>	 <48E80E60.8080106@zytor.com>	 <86802c440810041849g421ff524pf987f6c872e1d12a@mail.gmail.com>	 <48E81DED.7050902@zytor.com> <86802c440810041859s3695ff66v1833193f737551c8@mail.gmail.com>
In-Reply-To: <86802c440810041859s3695ff66v1833193f737551c8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Sat, Oct 4, 2008 at 6:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> There are some systems which, apparently, don't have RAM there.  Don't ask
>> me how or why.
> 
> very old system or
> very new system only have super big cache?
> 

Very new system.  That's all I know.  Don't know if they actually 
shipped, but it caused a lot of problems and I recommended to the OEM 
that they fix that.

	-hpa
