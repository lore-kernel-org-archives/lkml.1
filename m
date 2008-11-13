Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbYKMAcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbYKMAcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbYKMAcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:32:16 -0500
Received: from gw.goop.org ([64.81.55.164]:44542 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbYKMAcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:32:15 -0500
Message-ID: <491B758E.5090902@goop.org>
Date: Wed, 12 Nov 2008 16:32:14 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Bernhard Walle <bwalle@suse.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
References: <1226519089-21647-1-git-send-email-bwalle@suse.de> <491B398C.9090207@goop.org> <491B681B.6040405@kernel.org>
In-Reply-To: <491B681B.6040405@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> resource_size_t should always be 64-bit on PAE now.
>>
>>     
>
> Yes, but this would affect non-PAE kernels too.
>   

Yeah, I overlooked the comment about non-PAE.  Should we just make 
resource_size_t 64 bits all the time?  Or ignore inaccessible resources?

    J
