Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbYDILap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbYDILap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYDILag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:30:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40424 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYDILag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jPuVwMu5bzN88CBEMqfM5+0+atASsn57QEiht9SCpqf4GC2N+r1oPlaztEgBqQ24aDJGT0R7eIxTtyGbOFybCZ9vz8ZLhtOFV+uacpNjJU23E4fDF3W022TYmA1KdVDV3xiiwVI6epREGGqY6rcOrLWyJUtM1yBr2vDNXUh74Do=
Message-ID: <47FCA7FA.3010008@gmail.com>
Date: Wed, 09 Apr 2008 13:26:50 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for April 9
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>	<d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com>	<20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au>
In-Reply-To: <20080409212719.7d834c13.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell pisze:
> Hi Jacek,
> 
> On Wed, 9 Apr 2008 21:09:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Thanks for the report, can you please send us your .config, please?
> 
> Don't worry about it, I found the problem.
> 
> It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 ("x86:
> cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree seems to have
> missed some places.
> 

Yep, I did the same. You can find patch, which renames changes VM_MASK 
to X86_VM_MASK across all files in arch/x86/kernel, here: 
http://pin.if.uz.zgora.pl/~difrost/linux-next/09042008/

-Jacek
