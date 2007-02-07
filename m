Return-Path: <linux-kernel-owner+w=401wt.eu-S1030503AbXBGA7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503AbXBGA7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030504AbXBGA7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:59:41 -0500
Received: from terminus.zytor.com ([192.83.249.54]:34517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503AbXBGA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:59:41 -0500
Message-ID: <45C9246F.9050300@zytor.com>
Date: Tue, 06 Feb 2007 16:59:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : Re : Re : Re : [PATCH] Compressed ia32 ELF file generation
 for loading by Gujin 1/3
References: <965140.82745.qm@web26914.mail.ukl.yahoo.com>
In-Reply-To: <965140.82745.qm@web26914.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain wrote:
> H. Peter Anvin wrote:
>> I've long wished that someone would do a proper 16-bit x86 port of gcc; 
> 
>> however, the .code16gcc is usually good enough, although it produces 
>> code which is a lot bigger than it needs to be.
> 
>   It is only that much bigger if you compare to 16 bits integer compilers,
>  but once you deal with 32 bits integers in real mode you have one extra byte
>  out of the two - which is still better than dealing with dx:ax.
> 
>  Last time I compiled (long time ago) some piece of code with and without
>  .code16gcc it was approx 15% bigger - approx what you get when optimising.
> 

That's not a valid comparison, because you're using 32-bit registers to 
hold 16-bit pointers, and then sticking 67 prefixes on completely 
unnecessarily.

	-hpa
