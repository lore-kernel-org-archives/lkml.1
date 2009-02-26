Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZBZVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZBZVEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZBZVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:04:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZBZVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:04:34 -0500
Message-ID: <49A70379.3050306@zytor.com>
Date: Thu, 26 Feb 2009 13:02:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<20090226025043.GJ1363@mit.edu>	<20090226030735.GA16891@parisc-linux.org>	<yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com> <yq1iqmxey1o.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1iqmxey1o.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
> 
>>> Quick answer from one of my contacts.  Desktop drives will indeed
>>> ship with an alignment of 1(*).  The alignment is hardwired at time
>>> of manufacture and can't be changed.
>>>
> 
> hpa> Oh God.
> 
> hpa> This is a disaster.
> 
> Rationale being that modern Microsoft operating systems know how to
> interpret the alignment bits.  Legacy XP will work without changes
> thanks to the shifted alignment.  And Vista+ will do the right thing to
> align partition 1 to what the drive reports.
> 
> Also note that Windows only aligns the first partition.  That's
> something we need to be aware of when setting up dual boot systems.
> 

Yeah, but all of this completely breaks the disk image abstraction, 
which is a very powerful paradigm.

	-hpa

