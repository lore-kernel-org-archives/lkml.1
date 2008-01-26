Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYAZAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYAZAQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbYAZAQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:16:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:30883 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYAZAQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j+b7HLi7ELuL3GNnRG0H7qDWmTCbhdjc6fU+jioHKnw9OXptS4G5UrizF835cFSec4KXbE6LmPp7uMaKAaggO9YAaf44ROi+XqYhWubUNMCYkcFQTnHeh/RAB85djPuN+JmDihQmqDFLFECv4Bhr7CqGYkuLSz8C3vl7ftYiKUk=
Message-ID: <86802c440801251616wb50fa15j8671de0200dad922@mail.gmail.com>
Date: Fri, 25 Jan 2008 16:16:20 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v2
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.999999.0801251858450.4388@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801211209.23901.yinghai.lu@sun.com>
	 <alpine.DEB.0.999999.0801211635480.6668@p34.internal.lan>
	 <200801221950.06477.yinghai.lu@sun.com>
	 <alpine.DEB.0.999999.0801251858450.4388@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 4:01 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
...
> Tried it, it worked successfully!
>
> With stock kernel, previous way I had to use it was mem=8832M and top
> showed this:
>
> top - 18:53:52 up 1 min,  2 users,  load average: 1.03, 0.30, 0.10
> Tasks: 169 total,   1 running, 168 sleeping,   0 stopped,   0 zombie
> Cpu(s):  6.1%us,  2.6%sy,  4.5%ni, 81.3%id,  5.5%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   8039464k total,  1288948k used,  6750516k free,     3640k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   178528k cached
>
> With kernel you mentioned and use e820 v3:
>
> top - 18:48:13 up 3 min,  6 users,  load average: 1.67, 0.68, 0.25
> Tasks: 195 total,   2 running, 193 sleeping,   0 stopped,   0 zombie
> Cpu(s): 18.5%us,  1.2%sy,  1.6%ni, 74.8%id,  3.9%wa,  0.0%hi,  0.0%si,  0.0%st
> Mem:   8037668k total,  1438732k used,  6598936k free,     6844k buffers
> Swap: 16787768k total,        0k used, 16787768k free,   273928k cached
>
> No append mem= required.
>


thanks

any chance to try 32 bit with higemem64 option?

YH
