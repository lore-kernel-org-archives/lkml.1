Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbXCOXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbXCOXkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXCOXkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:40:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXCOXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:40:48 -0400
Message-ID: <45F9D974.1050309@zytor.com>
Date: Thu, 15 Mar 2007 16:40:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alon Bar-Lev <alon.barlev@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REPOST] x86_64, i386: Add command line length to boot
 protocol
References: <20070315210516.GA28998@strauss.suse.de> <9e0cf0bf0703151416r644e5302t9e053eae24d9d398@mail.gmail.com>
In-Reply-To: <9e0cf0bf0703151416r644e5302t9e053eae24d9d398@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alon Bar-Lev wrote:
> Hello,
> 
> I really don' t understand why you insist that the boot protocol
>> =2.02 had 255 limit!
> Please remove this from the description.
> You want to add size, that's OK, but please don't mess with previous
> definitions.
> Boot protocol 2.02 introduced the null terminated string truncated by
> kernel, which can be at any size.
> 

Well, except for a very brief window, the limit *was* 255.  If the boot 
loader wants to verify nontruncation, this is a valid concern.

	-hpa
