Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYH0WSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYH0WSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYH0WSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:18:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYH0WSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:18:13 -0400
Message-ID: <48B5D29D.9080209@zytor.com>
Date: Wed, 27 Aug 2008 15:18:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: C language lawyers needed
References: <adaod3ef82e.fsf@cisco.com> <48B5CE61.8020809@zytor.com> <20080827221711.GE28946@ZenIV.linux.org.uk>
In-Reply-To: <20080827221711.GE28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Aug 27, 2008 at 03:00:01PM -0700, H. Peter Anvin wrote:
>> Looks like a gcc bug to me.
>>
>> 0xff000000 is unsigned, like any hexadecimal constant.
> 
> Not any.  Ones that do not fit into range of int but do fit into the range
> of unsigned are.
> 

Crap, I keep having a stale/bogus bit set for that since I don't know when.

	-hpa
