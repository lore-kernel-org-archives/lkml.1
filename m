Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbYCGE4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbYCGE4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 23:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYCGE4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 23:56:13 -0500
Received: from mail-out3.apple.com ([17.254.13.22]:64505 "EHLO
	mail-out3.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYCGE4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 23:56:11 -0500
X-AuditID: 11807135-a2cbcbb000000a4f-9d-47d0caeadfbb
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Andrew Haley <aph@redhat.com>,
       Aurelien Jarno <aurelien@aurel32.net>, Michael Matz <matz@suse.de>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Message-Id: <85DD8EBE-C020-4192-9914-3046350A4548@apple.com>
From: Chris Lattner <clattner@apple.com>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20080306220610.GB31833@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Date: Thu, 6 Mar 2008 20:56:09 -0800
References: <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net> <47CFBF28.4060309@redhat.com> <871w6ogjnu.fsf@basil.nowhere.org> <84fc9c000803060406u7dfa0d38ve8af3154bf5064f9@mail.gmail.com> <20080306173438.GH17267@synopsys.com> <84fc9c000803061254i5865f68ev11fcfd08b698c58f@mail.gmail.com> <47D05A70.40008@zytor.com> <20080306220610.GB31833@one.firstfloor.org>
X-Mailer: Apple Mail (2.919.2)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 6, 2008, at 2:06 PM, Andi Kleen wrote:

> On Thu, Mar 06, 2008 at 12:56:16PM -0800, H. Peter Anvin wrote:
>> Richard Guenther wrote:
>>>
>>> A patched GCC IMHO makes only sense if it is always-on, yet  
>>> another option
>>> won't help in corner cases.  And corner cases is exactly what  
>>> people seem
>>> to care about.  For this reason that we have this single release,  
>>> 4.3.0,
>>> that
>>> behaves "bad" is already a problem.
>>>
>>
>> The option will help embedded vendors who can guarantee that it's  
>> not a
>> problem.
>
> For very very low values of "help".
>
> To be realistic it is very unlikely anybody will measure a difference
> from a few more or a few less clds in a program. It's not that they're
> expensive instructions

They aren't?  According to http://www.agner.org/optimize/instruction_tables.pdf 
, they have a latency of 52 cycles on at least one popular x86 chip.

-Chris
