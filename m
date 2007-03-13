Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbXCMFhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbXCMFhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXCMFho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:37:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbXCMFho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:37:44 -0400
Message-ID: <45F6389F.5090009@zytor.com>
Date: Mon, 12 Mar 2007 22:37:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanfile: a script to clean up stealth whitespace
References: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org> <20070312221414.94977b7d.akpm@linux-foundation.org> <45F63790.2050407@zytor.com>
In-Reply-To: <45F63790.2050407@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>>
>> Fair enough.
>>
>> It'd be nice to have a clean-up-a-patch version of this.  So it does
>> all these things, except it only changes lines which start with ^+.
> 
> It can do everything except kill empty lines at the end of the file; a 
> patch simply doesn't contain enough information to know if blank lines 
> are inserted at the end of a file as opposed in the middle of the file.
> 
> It can, of course, be done if the unpatched material is available, 
> probably by applying the patch and seeing what happens.
> 

Correction: for a context/unified diff it can be done by observing that 
there is no context left at the end of the file.  It won't work if the 
file already have empty space at the end of it, but that's probably good 
enough.  I'll cook something up.

	-hpa
