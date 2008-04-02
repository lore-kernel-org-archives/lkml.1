Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYDBLBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYDBLBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYDBLBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:01:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:13763 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYDBLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iGbEIuckfbd8L0ERoKnIwQ/AWyUaOrf5cAqXK6arKNXhDvhvXnVMKmMar9ma/RNnLA/gZRc2T6s4h/CQS9h28Qu+NRVFkX0DKmIp5Y2NkxGMntK4A1/7S23TJlG+M3GJY3xOEO0Jw5whVfDomBc9anwBFbGEDyKtJcJYmDZ/Kmc=
Message-ID: <47F3678C.9000000@gmail.com>
Date: Wed, 02 Apr 2008 13:01:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Drop an empty byteorder/generic.h from being exported
 to userspace.
References: <alpine.LFD.1.00.0804012134300.10852@localhost.localdomain> <47F35DF5.5010201@gmail.com> <alpine.LFD.1.00.0804020656170.13637@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.00.0804020656170.13637@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2008 01:00 PM, Robert P. J. Day wrote:
> On Wed, 2 Apr 2008, Jiri Slaby wrote:
> 
>> On 04/02/2008 03:38 AM, Robert P. J. Day wrote:
>>> Since the entire meaningful contents of generic.h is wrapped by the
>>> __KERNEL__ test, drop it from being passed to userspace, and remove
>>> the now superfluous __KERNEL__ test.
>>>
>>> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>>>
>>> ---
>>>
>>>   is there some value in allowing an effectively empty header file to
>>> be exported to userspace?
>> Not breaking the userspace? The file is included in non-__KERNEL__
>> sections from byteorder/*_endian.h.
> 
> ok ... and the value of including a completely empty header file is
> ... ?

No value, you should just move those includes into the __KERNEL__ part.
