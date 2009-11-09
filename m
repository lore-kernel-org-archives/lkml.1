Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZKIJWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZKIJWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZKIJWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:22:07 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60023 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZKIJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Mp1nO4FQ94KiJ4gjr6mON94yPAOkL0SPYIqGbEI51blbun6rwNa7bfsQnumpMcLMAE
         0peqDYbd3CkjijbtseEgZ/Zny14leBiU1M7JGydFUKk+R/G4mNcKrnzbEqX4HQRftE/2
         e5gnkOM0FymBhGkB7IZkfCFhoiCnnWFdqU2/U=
Message-ID: <4AF7DF41.5080100@gmail.com>
Date: Mon, 09 Nov 2009 10:22:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits external
 to a process (v7)
References: <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu>
In-Reply-To: <20091109090143.GB24020@elte.hu>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 10:01 AM, Ingo Molnar wrote:
> So i guess renaming setrlimit to do_setrlimit and adding the syscall 
> from Neil's patch should bring the two series into sync, right?

Looks like that. I have a nit, 32-bit programs on 64-bit x86 won't work.
I think we should add compat handlers for ia32 emulation too?
