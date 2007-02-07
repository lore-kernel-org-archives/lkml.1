Return-Path: <linux-kernel-owner+w=401wt.eu-S965692AbXBGRND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965692AbXBGRND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965691AbXBGRND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:13:03 -0500
Received: from terminus.zytor.com ([192.83.249.54]:45817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965689AbXBGRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:13:01 -0500
Message-ID: <45CA0895.8040201@zytor.com>
Date: Wed, 07 Feb 2007 09:12:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading
 by Gujin 1/3
References: <923904.35193.qm@web26909.mail.ukl.yahoo.com>
In-Reply-To: <923904.35193.qm@web26909.mail.ukl.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain wrote:
>  I did try to remove by "sed" some structure easily converted, like:
>   mov 26(%ebx),%eax
>  by:
>   mov 26(%bx),%eax
> for all registers esi,edi,ebx,ebp but it saved so few bytes that I did not keep it.

Well, *of course*, since you still do all your pointer arithmetic in 
32-bit space, plus you can't convert all 32-bit modes this way.  This is 
a far cry from a proper port.

	-hpa
