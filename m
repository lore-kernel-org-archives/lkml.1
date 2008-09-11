Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYIKVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYIKVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYIKVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:43:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbYIKVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:43:51 -0400
Message-ID: <48C99110.8070206@zytor.com>
Date: Thu, 11 Sep 2008 14:43:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Harun Scheutzow <harun04@scheutzow.de>, linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de> <20080911191049.GB31271@csclub.uwaterloo.ca> <48C97338.5080502@zytor.com> <20080911210908.GC31271@csclub.uwaterloo.ca>
In-Reply-To: <20080911210908.GC31271@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
>>>
>> Well, you can always do that in-memory.
> 
> It still involves searching no matter where you do it.  With FAT-16 that
> means up to 2^16 clusters to search through.  With FAT-32 even more.  It
> doesn't have a cluster bitmap to speed things up.
> 

You don't, obviously, and the cluster links are fairly big.  Lipstick on 
a pig, and all that.  But it's prettier with the lipstick.

	-hpa
