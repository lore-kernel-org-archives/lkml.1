Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYI3Svg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYI3Svg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYI3Sv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:51:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55216 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYI3Sv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:51:26 -0400
Message-ID: <48E274F7.4080803@zytor.com>
Date: Tue, 30 Sep 2008 11:50:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: mtrr_cleanup prepare to make gran_size to	less
 1M
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <48E1A5E8.3030304@zytor.com> <20080930074552.GA19366@elte.hu> <20080930081141.GA29840@elte.hu>
In-Reply-To: <20080930081141.GA29840@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> Applied series to tip:x86/mtrr, thanks!
>> tested them and pushed it out into tip/master.
> 
> btw., now that we've got wide enough exposure (a kernel release), could 
> we please flip around the default of CONFIG_MTRR_SANITIZER and make it 
> default-y? This feature should only produce a worse result if there's a 
> bug in that code, right?
> 

Yes.  Furthermore, right now the code has to be enabled *and* a kernel 
command line option has to be passed.  I suspect we eventually want to 
runtime-enable it by default, too.

	-hpa
