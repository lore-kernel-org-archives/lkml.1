Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbYEBHzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbYEBHzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYEBHzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:55:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:28514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbYEBHzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YfIPhMdngXSdb5sns36vZJAgwXVW91wxE8TM+7JR9fuDLaAosbOcAowPwSc5uTkT66j7Vi6eZaxy3Amwy8Dh7/pNz0GhoSo7hFYHTiAQRd49JC9ng0P9Q8KgmMWQlrJgRvG3/03VQmYxV+Nn2rOPCI02rF+yiv9Or3VlWxsbIqg=
Message-ID: <481AC8F6.1010504@gmail.com>
Date: Fri, 02 May 2008 09:55:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com> <20080502080017.GP20451@one.firstfloor.org>
In-Reply-To: <20080502080017.GP20451@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2008 10:00 AM, Andi Kleen wrote:
> On Thu, May 01, 2008 at 11:58:18AM +0200, Jiri Slaby wrote:
>> Commit 85eb69a16aab5a394ce043c2131319eae35e6493 introduced 512 MiB
>> sized kernel and 1.5 GiB sized module space but omitted to change
>> documentation properly. Fix that.
>>
>> [Wasn't the hole intentional protection hole?]
> 
> Yes it was.

Thanks. Going to post a patch to re-introduce the hole.
