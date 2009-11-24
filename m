Return-Path: <linux-kernel-owner+w=401wt.eu-S934467AbZKXXmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467AbZKXXmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934386AbZKXXmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:42:07 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35540 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934380AbZKXXmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J8L1UKBAD+K7LS6gaDNE7UrSEwACNzVi2aebnHm8tdG8NJFQ29G/InRCfI/RVie9ji
         OqvqMTC5INDxpT7vbSZbuLZ4IbA4lY3vzpm4m+zf9w71jYw0ZBCeN8yixFp6l8m/IpXw
         VpTCHorapgi+Cq17dOC9jH8e3dewLY1x8wiug=
Message-ID: <4B0C6F4A.1080304@gmail.com>
Date: Tue, 24 Nov 2009 17:42:02 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Otavio Salvador <otavio@ossystems.com.br>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>	 <20091123134002.bac1e664.akpm@linux-foundation.org>	 <4B0B1B62.2030302@gmail.com>	 <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>	 <4B0B36F0.30109@gmail.com> <be7a9f3d0911240329r50ddb22dvd933f01d296295c1@mail.gmail.com>
In-Reply-To: <be7a9f3d0911240329r50ddb22dvd933f01d296295c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 05:29 AM, Otavio Salvador wrote:
> Hello Robert,
>
> On Mon, Nov 23, 2009 at 11:29 PM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> Looking at the BIOS manual on their web site:
>>
>> ftp://download@ftp.dmp.com.tw/vortex86sx/Vortex86SX_BIOS_Manual.pdf
>>
>> you can try toggling a few of the options: Try switching OnBoard IDE Operate
>> Mode between Legacy Mode and Native Mode. If the kernel and the actual
>> device disagree here, that could cause IRQ delivery problems. You can also
>> try playing with the "Plug&  Play OS" setting.
>
> The machine with me has no "OnBoard IDE Operate Mode" option. "Plug&
> Play OS" has been tried with "Yes" and "No".
>
> If the kernel and the actual device disagree, could it  also "break"
> the ethernet adaptor? This also doesn't work.

Well, the ethernet adapter would likely be a different problem. Do you 
get any interrupts showing up in /proc/interrupts for either the disk or 
the network adapter?
