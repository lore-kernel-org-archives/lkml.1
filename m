Return-Path: <linux-kernel-owner+w=401wt.eu-S2992896AbXCCBtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992896AbXCCBtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992898AbXCCBtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:49:19 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:38926 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992896AbXCCBtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:49:18 -0500
Message-ID: <45E8D406.7010008@linuxtv.org>
Date: Fri, 02 Mar 2007 20:48:54 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [patch 0/9] 2.6.19-stable review
References: <20070227000538.GA6283@kroah.com> <45E49329.5080509@linuxtv.org> <20070303012300.GD6496@suse.de>
In-Reply-To: <20070303012300.GD6496@suse.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Feb 27, 2007 at 03:23:05PM -0500, Michael Krufky wrote:
>> Greg KH wrote:
>>> This is the start of the stable review cycle for the 2.6.19.6 release.
>>>
>>> This will probably be the last release of the 2.6.19-stable series, so
>>> if there are patches that you feel should be applied to that tree,
>>> please let me know.
>>>
>>> There are 9 patches in this series, all will be posted as a response to
>>> this one.  If anyone has any issues with these being applied, please let
>>> us know.  If anyone is a maintainer of the proper subsystem, and wants
>>> to add a Signed-off-by: line to the patch, please respond with it.
>>>
>>> These patches are sent out with a number of different people on the Cc:
>>> line.  If you wish to be a reviewer, please email stable@kernel.org to
>>> add your name to the list.  If you want to be off the reviewer list,
>>> also email us.
>>>
>>> Responses should be made by Thursday March 1 00:00 UTC.  Anything
>>> received after that time might be too late.
>>>
>>> The whole patch set can be downloaded at:
>>>         kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.19.6-rc1.gz
>>>
>>> thanks,
>>>
>>> the -stable release team
>> Greg,
>>
>> I still have three DVB patches that need to go to 2.6.19.y, the dvbdev patch
>> being most important.  I sent this dvbdev patch to you during the 2.6.19.5
>> review period and expected it to surface this time around, but maybe our email
>> paths have crossed.
>>
>> Since I am unable to send patches inline from my current location, I've posted
>> the three pending patches for 2.6.19.y here:
>>
>> http://linuxtv.org/~mkrufky/stable/2.6.19.y/
>>
>> Please add these if possible.  Again, the
>> "dvbdev-fix-illegal-re-usage-of-fileoperations-struct" patch is the most
>> important one of these.
> 
> Argh, I forgot these :(
> 
> Do you want me to do a new 2.6.19-stable release with these patches in
> it?  It's my fault I didn't get this in, so I don't really mind if you
> feel it is important enough (it doesn't take that long to spin another
> kernel release.)
> 
> thanks,
> 
> greg k-h

The dvbdev patch is pretty important, fixes a horrible problem, although the case for
it to occur is rare.  The other two patches are of the "obviously correct - minimal change" 
type.

If it isnt too much trouble, then yes, it is worth it to push a new release because of the
dvbdev patch.

However, please chop the "backported from" and "cherry picked from" lines from those patches.
I cherry-picked them from Mauro's tree, but he wiped it out and re-pushed those changes in
before Linus merged them....  so, the actual changesets in Linus' tree have different hashes.

(i removed those old hashes from the patches that I posted on linuxtv.org)

As for the 2.6.20.y patches, should I email those to you inline or can you just grab them from
the linuxtv.org www server?  ( http://linuxtv.org/~mkrufky/stable/2.6.20.y/ )

Thanks,

Mike Krufky
