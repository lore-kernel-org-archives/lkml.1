Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbYHDOyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbYHDOyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYHDOyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:54:08 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:58597 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYHDOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:54:07 -0400
Message-ID: <38332.166.70.238.45.1217860413.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <4897070E.5050509@s5r6.in-berlin.de>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
    <43318.166.70.238.45.1217792210.squirrel@webmail.wolfmountaingroup.com>
       <1217808849.2328.43.camel@localhost.localdomain>
    <58898.166.70.238.45.1217816372.squirrel@webmail.wolfmountaingroup.com>
    <4897070E.5050509@s5r6.in-berlin.de>
Date: Mon, 4 Aug 2008 08:33:33 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, "Josh Boyer" <jwboyer@gmail.com>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK,  Sounds like I get a D- on patch format submission.   I will rework
the patches, switch back to GPL2 (since I guess GPL 3 is still not there
yet) and clean up this list of issues.   ULONG, etc. is Microsoft syntax
for cross platform compatibility.  Since this is a LINUX SPECIFIC PATCH,
I'll rip out and rework the Gates-isms in the code.

All that aside, the damn works so at least folks can start using it while
I perform code beautification.

Jeff


> jmerkey@wolfmountaingroup.com wrote:
>>> On Sun, 2008-08-03 at 13:36 -0600, jmerkey@wolfmountaingroup.com wrote:
>>>>
>>>> This patch is formally submitted for consideration for inclusion in
>>>> the
>>>> base linux kernel.
>>>>
>>>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.26-ia32-08-02-08.patch
>>>
>>> Formally submitted patches should be sent to the list inline.
>>> Reviewing
>>> something on an FTP server just becomes that much harder.
>>>
>>> josh
>>>
>>>
>>
>> Submitted as inline patches.
>
> Some non-technical comments to the patch series:
>   - Each patch posting in a patch series should have an own Subject and
>     changelog which specifically describes the included patch.
>   - The Developer's Certificate of Origin is written simply as a single
>     line:
>     Signed-off-by: Jeffrey Vernon Merkey <email@address>
>     This line needs to be included in the changelog of each patch, i.e.
>     precedes the diff.  (Tools which harvest patches from mboxes are
>     trained to pick the changelog up from before the diff.)
>   - The MUA rewrapped some lines.
>   - File name and date of last change are redundant information and are
>     better left out of the source files.
>   - Understandably for a port from other kernels, there are clashes with
>     Linux kernel's coding style like CamelCase names, comment style,
>     indentations.
>   - Why define LONGLONG, WORD, BYTE and so on?  They could be plain
>     unsigned char etc., or u8 etc. if you like it brief.
>   - Boolean values should be the standard true and false, not locally
>     defined TRUE and FALSE.
>   - Usually the #include's are not collected in an intermediary header
>     (as in patch 7/25) but put directly into the files which require
>     a particular #include.
>
> I haven't looked in detail at the patches; it's far out of my area of
> experience...
> --
> Stefan Richter
> -=====-==--- =--- --=--
> http://arcgraph.de/sr/
>


