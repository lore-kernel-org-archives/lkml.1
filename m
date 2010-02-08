Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab0BHDb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 22:31:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35155 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab0BHDb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 22:31:26 -0500
Message-ID: <4B6F84AA.70402@zytor.com>
Date: Sun, 07 Feb 2010 19:27:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: James Cloos <cloos@jhcloos.com>
CC: Mark Lord <kernel@teksavvy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain>	<alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>	<4B6E4793.3010201@teksavvy.com> <m3k4uo275s.fsf@lugabout.jhcloos.org>
In-Reply-To: <m3k4uo275s.fsf@lugabout.jhcloos.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 11:10 AM, James Cloos wrote:
>>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:
> 
> Mark> I just wish the GNU tar folk had the sense to combine -z and -j
> Mark> into a single flag.
> 
> Try the -a flag:
> 
>  -a, --auto-compress   use archive suffix to determine the compression program
> 
> (Which does seem to be on by default, now, as mentioned in the other reply.)
> 

For decompression it should use magic numbers, not filenames.  For
compression, using filenames as a heuristic I guess makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

