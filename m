Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXA3D0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXA3D0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXA3D0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:26:06 -0500
Received: from dvhart.com ([64.146.134.43]:41260 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXA3D0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:26:04 -0500
Message-ID: <45BEBAC9.6020809@mbligh.org>
Date: Mon, 29 Jan 2007 19:26:01 -0800
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.8 (X11/20061117)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
Cc: suparna@in.ibm.com, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>,
       =?ISO-8859-1?Q?=22S=E9bastien_Dugu=E9_=40qubit=2Ein=2Eibm=2Ecom=22?= 
	<sebastien.dugue@bull.net>
Subject: Re: 2.6.20-rc6-mm1
References: <20070127234928.64d8e437.akpm@osdl.org>	<45BCD5A8.4090400@mbligh.org>	<20070128150133.b4c9b093.akpm@osdl.org>	<20070130024231.GA9497@in.ibm.com> <20070129184228.49fd48e7.akpm@osdl.org>
In-Reply-To: <20070129184228.49fd48e7.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 30 Jan 2007 08:12:31 +0530
> Suparna Bhattacharya <suparna@in.ibm.com> wrote:
> 
>> On Sun, Jan 28, 2007 at 03:01:33PM -0800, Andrew Morton wrote:
>>> On Sun, 28 Jan 2007 08:56:08 -0800
>>> "Martin J. Bligh" <mbligh@mbligh.org> wrote:
>>>
>>>>> - It seems that people have been busy creating the need for this.  I had to
>>>>>   apply over sixty patches to this tree to fix post-2.6.20-rc4-mm1 compilation
>>>>>   errors.  And a number of patches were dropped due to no-compile or to
>>>>>   runtime errors.  Heaven knows how many runtime bugs were added.
>>>> dbench seems to panic on xfs / cfq ?
>>> OK, I'll dump git-block.patch.  That means that the fsaio patches get
>>> temporarily dropped as well as they depend on git-block changes somewhat.
>> Would you like me to rework these back again to not depend on git-block ?
> 
> Is OK thanks, I now have a git-block minus CFQ changes, so I have restored the fsaio
> patches.

On a happy note - mm2 seems to pass testing much better ;-)

M.

