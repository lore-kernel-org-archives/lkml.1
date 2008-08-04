Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYHDJ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYHDJ03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYHDJ0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:26:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:38869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbYHDJ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:26:21 -0400
Message-ID: <4896CB17.8050701@kernel.org>
Date: Mon, 04 Aug 2008 18:25:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Satish Eerpini <eerpini@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Installer
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>	 <20080803210051.GF7442@cs181140183.pp.htv.fi>	 <93655eb70808032045vd6130e9m147d3e3ae8b159b5@mail.gmail.com> <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
In-Reply-To: <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 Aug 2008 09:26:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satish Eerpini wrote:
>> Replacing the normal build output with something different doesn't make
>> anything easier.
>>
>> Especially considering that your "once the .config file is set" seems to
>> assume the user already configured the kernel himself...
>>
> 
> i am not just trying to replace the output , i am not a stupid to
> waste my weekend sitting just to replace the output  :-),
> if u are interested , u can check out the entire TODO for the app here
> http://satish.playdrupal.com/?q=node/2
> 
> but in the process i am stuck at deciding the no of files that will be
> compiled , given that representing the entire compilation
> process as a progress bar , would give a clear idea of " how much is
> over" and "how much is left" !!!

make -n makes make do a dry-run but kbuild is a pretty complex beast and
you might have to jump through some loops to get the information you want.

-- 
tejun
