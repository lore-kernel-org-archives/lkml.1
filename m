Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZKSJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZKSJu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZKSJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:50:25 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64965 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZKSJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kOvqH6QKHbZwU+r7SqRDT5RLmRx9BHg3dfg5CruXTLX0iNwoFN3dCU3+inpe+Foaxw
         nTLrJbr6gckEr6cMdGabxE5FFuMFs1q7IzTtMFtaM9dd1SxQo6MOXepym9NHTn5Uf68L
         N/U9vTZfJwWKQ1cwPB5F0IsP4hrXG59G8UEVg=
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 17:50:30 +0800
Message-ID: <cb9ecdfa0911190150w4edbacdfp24a7069c618193f4@mail.gmail.com>
Subject: How to move two valuables to x86 CPU register ebx, ecx by using AT&A 
	inline asm.
From: Johnny Hung <johnny.hacking@gmail.com>
To: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:
    I want to move two local valuables to x86 arch CPU ebx, ecx
register and do outb cpu instruction by using AT&A inline asm in
kernel driver.  The following code was I wrote but gcc report syntax
error:
==
    unsigned int val = 10;
    unsigned int tmp = 5;
    ....
    __asm__ volatile ("movl %0, %%ebx"
          "movl %1, %%ecx"
          "outb $0x27, $0xb2"
          :
          :"r"(val), "r"(tmp)
          :"%ebx", "%ecx"
   );

Does anyone can point me out. Any reply is appreciated.

BRs, H. Johnny
