Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXD2Rv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXD2Rv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXD2Rv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:51:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbXD2Rv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:51:58 -0400
Message-ID: <4634DB24.7020408@zytor.com>
Date: Sun, 29 Apr 2007 10:51:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org> <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
In-Reply-To: <4634483E.9030307@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Eric W. Biederman wrote:
>> All it does is set a flag that tells a bootloader.
>> "Hey. I can run when loaded a non-default address, and this is what
>>  you have to align me to."
>>
>> All relocation processing happens in the kernel itself.
>>   
> 
> Is it possible to decompress and extract the kernel image from the
> bzImage without executing it?  Ie, is there enough information to find
> the compressed data part of the bzImage by inspection?
> 
> At some point we'll need to change the Xen domain builder to handle
> bzImage files, and it would be best if we didn't need to run them.
> 

Probabilistically, you might be able to (search for a gzip header), but
it is *definitely* not guaranteed by protocol.

	-hpa
