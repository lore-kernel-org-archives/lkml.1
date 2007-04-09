Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXDIFRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXDIFRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXDIFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:17:14 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:44362 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXDIFRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:17:13 -0400
Date: Mon, 09 Apr 2007 01:16:33 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <1176092271.6355.16.camel@Homer.simpson.net>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704090116.37329.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <200704081356.48843.gene.heskett@gmail.com>
 <1176092271.6355.16.camel@Homer.simpson.net>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Mike Galbraith wrote:
>On Sun, 2007-04-08 at 13:56 -0400, Gene Heskett wrote:
>> On Sunday 08 April 2007, Mike Galbraith wrote:
>> >On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:
>> >> That seems to be the killer loading here, building a kernel (make
>> >> -j3) doesn't seem to lag it all that bad.  One session of gzip
>> >> -best makes it fall plumb over though, which was a disappointment.
>> >
>> >Can you make a testcase that doesn't require amanda?
>> >
>> >	-Mike
>>
>> Sure.  Try 'tar czf nameofarchive.tar.gz /path/to-dir-to-be-backed-up'
>>
>> Or, from the runtar log from this morning, and this is all one line:
>>
>> runtar.20070408022016.debug:running: /bin/tar: 'gtar' '--create'
>> '--file' '-' '--directory' '/usr/dlds-rpms' '--one-file-system'
>> '--listed-incremental'
>> '/usr/local/var/amanda/gnutar-lists/coyote_usr_dlds-rpms_1.new'
>> '--sparse' '--ignore-failed-read' '--totals' '--exclude-from'
>> '/tmp/amanda/sendbackup._usr_dlds-rpms.20070408022016.exclude' '.'
>>
>> and amanda will if requested, pipe that output through a |gzip -best,
>> and its this process that brings the machine to the table begging for
>> scraps like a puppy.  Tar by itself can be felt but isn't bad.
>
>So tar -cvf - / | gzip --best | tar -tvzf - should reproduce the
>problem?
>
>	-Mike

That looks as if it should demo it pretty well if I understand correctly 
everything you're doing there.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
In /users3 did Kubla Kahn
A stately pleasure dome decree,
Where /bin, the sacred river ran
Through Test Suites measureless to Man
Down to a sunless C.
