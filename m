Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYJ3SsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYJ3SsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYJ3Sr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:47:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbYJ3Sr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:47:58 -0400
Message-ID: <490A012B.90305@redhat.com>
Date: Thu, 30 Oct 2008 14:47:07 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org
Subject: Re: how much license information inside the kernel ?
References: <488434293@web.de>
In-Reply-To: <488434293@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> hi,
> 
> i found that there is a LOT of repeating licensing information in the
> kernel.
> 
> for me,
> 
> find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU
> General Public License|Free Software Foundation|version 2 of the
> License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A
> PARTICULAR"
> 
> gives a file sized ~3.5M
> 
> That`s more than 1% of the kernel source.
> 
> What about the idea to shorten that licening information to a minimum
> , e.g. by shrinking that to a single, catchy line ,  linking to a
> special licensing file like COPYING or linking to the FSF website ?
> 
> please no flames, i know this idea could be pure dynamite for some
> people - but i thought 3.5M is worth this mail.
> 
> regards roland
> 
> ps: i`m not sure if that has been discussed already, but i didn`t
> find that in the archive. please ignore, otherwise.

It may be 3.5 MB uncompressed, but disk space is cheap, and repeated 
strings compress extremely well to save bandwidth.  If you work with the 
kernel source enough for this to be an issue, you should use git. 
You'll download these license headers once, and never again unless the 
copyright info gets changed by a patch.  From a technical perspective, 
the problem isn't nearly as bad as it looks, and it keeps the lawyers 
happy, so it's really not worth messing with.  There's plenty of 
lower-hanging fruit in unifying drivers for similar hardware, unifying 
32-bit and 64-bit architectures, and other things that make the code 
more maintainable.

-- Chris
