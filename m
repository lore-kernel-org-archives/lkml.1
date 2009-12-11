Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZLKH1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZLKH1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZLKH06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:26:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZLKH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:26:57 -0500
Message-ID: <4B21F42F.4070400@zytor.com>
Date: Thu, 10 Dec 2009 23:26:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: James Andrewartha <jamesa@daa.com.au>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>	<20090226025043.GJ1363@mit.edu>	<20090226030735.GA16891@parisc-linux.org> <yq1myc9g9ua.fsf@sermon.lab.mkp.net> <4B21EF54.9070609@daa.com.au>
In-Reply-To: <4B21EF54.9070609@daa.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 11:05 PM, James Andrewartha wrote:
> Martin K. Petersen wrote:
>>>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:
>>
>> Matthew> Lowest aligned logical block address=0
>>
>> Matthew> This disagrees with Martin's assertion.
>>
>> The original roadmap was to transition to 4KB sectors in 2006,
>> coinciding with the Vista release.
>>
>> Given how long this has taken (we're now talking ~2011 for GA) it may
>> very well be that the alignment knobs will be unused because everybody
>> will be using Vista or 7 by then.
> 
> The plan does seem to have changed - WD's shipping 4k sector drives that
> are sane and require a drive jumper or tool for WinXP and old cloning
> utilities.
> 
> http://techreport.com/discussions.x/18115
> http://wdc.com/en/products/advancedformat/
> http://www.wdc.com/wdproducts/library/whitepapers/en/2579-771430-A00.pdf
> 

Even more important, the alignment can be changed as opposed to being
fixed for the manufacture of the disk.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

