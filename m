Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbXCMFdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbXCMFdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXCMFdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:33:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbXCMFdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:33:20 -0400
Message-ID: <45F63790.2050407@zytor.com>
Date: Mon, 12 Mar 2007 22:33:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanfile: a script to clean up stealth whitespace
References: <200703121920.l2CJK24N008104@tazenda.hos.anvin.org> <20070312221414.94977b7d.akpm@linux-foundation.org>
In-Reply-To: <20070312221414.94977b7d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Mon, 12 Mar 2007 12:16:30 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>> This script cleans up various classes of stealth whitespace.  In
>> particular, it cleans up:
>>
>> - Whitespace (spaces or tabs)before newline;
>> - DOS line endings (CR before LF);
>> - Space before tab (spaces are deleted or converted to tabs);
>> - Empty lines at end of file.
> 
> Fair enough.
> 
> It'd be nice to have a clean-up-a-patch version of this.  So it does
> all these things, except it only changes lines which start with ^+.

It can do everything except kill empty lines at the end of the file; a 
patch simply doesn't contain enough information to know if blank lines 
are inserted at the end of a file as opposed in the middle of the file.

It can, of course, be done if the unpatched material is available, 
probably by applying the patch and seeing what happens.

Let me know if you still want it; I'll whip it up.

	-hpa
