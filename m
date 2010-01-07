Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679Ab0AGXyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0AGXyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536Ab0AGXyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:54:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0AGXyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:54:46 -0500
Message-ID: <4B467433.3060701@zytor.com>
Date: Thu, 07 Jan 2010 15:54:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: Paul Mackerras <paulus@samba.org>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: add close()/closedir() calls when needed
References: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>	 <20100107212912.GB10344@brick.ozlabs.ibm.com> <a4423d671001071444k2cb61c0blb1bb175ab0098a9f@mail.gmail.com>
In-Reply-To: <a4423d671001071444k2cb61c0blb1bb175ab0098a9f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 02:44 PM, Alexander Beregalov wrote:
> 2010/1/8 Paul Mackerras <paulus@samba.org>:
>> On Thu, Jan 07, 2010 at 07:40:46PM +0300, Alexander Beregalov wrote:
>>
>>> Close file and directory descriptors before exiting or dying.
>>
>> Your patch description doesn't say why that's a good thing to do, and
>> it's not obvious to me at least.  Please explain the motivation in
>> your patch description.
> 
> Isn't it a good style to close files after use and before exit?

exit() closes all files, so it's redundant.

It's "good style" in the sense that it can help librarization, though.

	-hpa
