Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbYEYL7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbYEYL7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYEYL67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:58:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33271 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbYEYL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:58:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48395456.9070202@s5r6.in-berlin.de>
Date: Sun, 25 May 2008 13:58:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Jan Kara <jack@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu>
In-Reply-To: <20080524224554.GA5970@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sat, May 24, 2008 at 03:30:20PM -0700, Arjan van de Ven wrote:
>> Ted looked at these during the LF summit, and his conclusion was that
>> they're all media errors (eg USB unplug) that ext3 then did not handle
>> well at all. Maybe Ted has an update on this?
>>
> 
> Not really.  It's on my todo list but fixing a bug caused by users
> doing something stupid (pulling a mounted USB stick) has been lower
> than a number of other fires burning on my plate.  I'll try to get to
> it but a lot of other things I need to worry about have deadlines
> associated with them....

There are more reasons for connection loss than "user doing something 
stupid".  Firmware flaws for example.  Or SBP-2 re-login failing on a 
crowded FireWire bus.

Hot-removal capability is a fundamental requirement for a filesystem, 
just like for the block drivers and transport drivers.  (E.g. don't 
corrupt the kernel in case of unrecoverable IO failures.)

BTW, hfs+ is also buggy WRT connection loss.
-- 
Stefan Richter
-=====-==--- -=-= ==--=
http://arcgraph.de/sr/
