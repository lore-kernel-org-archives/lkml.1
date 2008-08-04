Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYHDNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYHDNmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYHDNme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:42:34 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51313 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYHDNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:42:33 -0400
Message-ID: <4897070E.5050509@s5r6.in-berlin.de>
Date: Mon, 04 Aug 2008 15:41:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>    <43318.166.70.238.45.1217792210.squirrel@webmail.wolfmountaingroup.com>    <1217808849.2328.43.camel@localhost.localdomain> <58898.166.70.238.45.1217816372.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <58898.166.70.238.45.1217816372.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
>> On Sun, 2008-08-03 at 13:36 -0600, jmerkey@wolfmountaingroup.com wrote:
>>>
>>> This patch is formally submitted for consideration for inclusion in the
>>> base linux kernel.
>>>
>>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.26-ia32-08-02-08.patch
>>
>> Formally submitted patches should be sent to the list inline.  Reviewing
>> something on an FTP server just becomes that much harder.
>>
>> josh
>>
>>
> 
> Submitted as inline patches.

Some non-technical comments to the patch series:
  - Each patch posting in a patch series should have an own Subject and
    changelog which specifically describes the included patch.
  - The Developer's Certificate of Origin is written simply as a single
    line:
    Signed-off-by: Jeffrey Vernon Merkey <email@address>
    This line needs to be included in the changelog of each patch, i.e.
    precedes the diff.  (Tools which harvest patches from mboxes are
    trained to pick the changelog up from before the diff.)
  - The MUA rewrapped some lines.
  - File name and date of last change are redundant information and are
    better left out of the source files.
  - Understandably for a port from other kernels, there are clashes with
    Linux kernel's coding style like CamelCase names, comment style,
    indentations.
  - Why define LONGLONG, WORD, BYTE and so on?  They could be plain
    unsigned char etc., or u8 etc. if you like it brief.
  - Boolean values should be the standard true and false, not locally
    defined TRUE and FALSE.
  - Usually the #include's are not collected in an intermediary header
    (as in patch 7/25) but put directly into the files which require
    a particular #include.

I haven't looked in detail at the patches; it's far out of my area of
experience...
-- 
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/
