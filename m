Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZAEOcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZAEOcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZAEOcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:32:10 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:2257 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbZAEOcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:32:09 -0500
Message-ID: <496219BD.1080905@cybernetics.com>
Date: Mon, 05 Jan 2009 09:31:25 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: 7eggert@gmx.de
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [DMAR] Fix endless "Unknown DMAR structure type" loop
References: <bOPDK-1i9-1@gated-at.bofh.it> <bOPNs-1u4-5@gated-at.bofh.it> <E1LItze-0001ij-Nx@be1.7eggert.dyndns.org>
In-Reply-To: <E1LItze-0001ij-Nx@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Avi Kivity <avi@redhat.com> wrote:
>
>   
>> (copying relevant people)
>>
>> Tony Battersby wrote:
>>     
>
>   
>>> +                            "Invalid 0-length structure\n");
>>>       
>
> This line is everything the reader of your message will see, (unless it happens
> not to be the first ACPI error). I would not be able to tell the cause without
> grepping the kernel source.
>
>
>   

Well, there is a PREFIX of "DMAR:" in the message too.  And I do not
think it is any less informative than any of the other error messages in
the same function, e.g. "Invalid DMAR haw", or "Unknown DMAR structure
type".

Tony
