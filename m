Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZHTVpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZHTVpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZHTVpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:45:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:50491 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753336AbZHTVpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:45:19 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/WdJwe2jPWpHRKH3XofbXBgd97O2t6fKNLfCe5fi
	ldNKmGo1FZphEv
Message-ID: <4A8DC3ED.4060005@gmx.de>
Date: Thu, 20 Aug 2009 23:45:17 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
CC: rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca, roland@redhat.com,
       James.Bottomley@HansenPartnership.com
Subject: Re: kernel segv with 2.6.31-rc6 ?
References: <20090820185550.979544E7A@hiauly1.hia.nrc.ca>
In-Reply-To: <20090820185550.979544E7A@hiauly1.hia.nrc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 08:55 PM, John David Anglin wrote:
>> The reason seems to be, that something in the newer gcc compilers changed to generate multiple sections all named ".text" for the PCREL17 relocations.
>> Older compilers named those sections ".text.1", ".text.2", ".text.3" and so forth.
>
> GCC has never generated ".text.1", etc, on parisc linux as far as I know.

Hmm, I don't like to disagree with an gcc-expert like you,but
I did pasted an objdump in my last mail, which shows that gcc did
generated .text.1, .text.2 and so on:

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00000000  00000000  00000000  00000034  2**0
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
...
   4 .text.1       00000000  00000000  00000000  000000b0  2**0
                   CONTENTS, ALLOC, LOAD, READONLY, CODE

Helge
