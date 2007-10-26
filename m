Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbXJZKmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbXJZKmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXJZKmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:42:32 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:4185 "EHLO
	smtp2.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbXJZKmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:42:31 -0400
Message-ID: <4721C44E.4000800@draigBrady.com>
Date: Fri, 26 Oct 2007 11:41:18 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Michael Lothian <mike@fireburn.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Possibility of adding -march=native to x86
References: <0EC33A59AA72084CA28B83816B40929F02682BB3@REEDXCLSXM01V03.rbsres01.net> <fc94aae90710251133j4bada173h6298242ece586b61@mail.gmail.com> <20071025185022.GP30533@stusta.de> <fc94aae90710251209n74e2cffbj2e3cdd321f36da0d@mail.gmail.com> <20071025191723.GQ30533@stusta.de> <fc94aae90710251232m117421e7ref3e5a6270ff25d2@mail.gmail.com> <20071025195020.GS30533@stusta.de> <fc94aae90710251312w2eba46e8h5d4f8715ad0e91b6@mail.gmail.com> <20071025202031.GU30533@stusta.de>
In-Reply-To: <20071025202031.GU30533@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Oct 2007 10:43:32.0427 (UTC) FILETIME=[0D9649B0:01C817BD]
X-CTCH-RefID: str=0001.0A0B0201.4721C400.00AF,ss=1,fgs=0
X-MXUniqueID: 85f69452-ff80-48cc-bf6b-f928f8a58990
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Oct 25, 2007 at 09:12:45PM +0100, Michael Lothian wrote:
>>> The MPENTIUM4 option does not only set -march=pentium4, it also enables
>>> several other options in arch/i386/Kconfig.cpu resulting in better
>>> performance.
>> How about an autodetect to set the right options here too using cpuid?
>>
>> With a warning of course that the code produced will be specifically
>> for the native cpu that it's compiled on.
> 
> If you don't know or can figure out yourself the CPU you have, you'd 
> better not compile your own kernel...

There also is the added variable of what your version of gcc supports.
The kernel gcc options would have to be the highest common factor.
See also http://www.pixelbeat.org/scripts/gcccpuopt

Pádraig.
