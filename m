Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbZCCLWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbZCCLWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZCCLWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:22:23 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:44224 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZCCLWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ioNIlLex3a9haj7Yiyx8zS8i69m9yZ4nfAU3X4VF2zRmY7qS5BhQtVhw5vkUQ1l9kn
         0mL0NXbnkvYPoCBv7eQta1bJ1VUx1aPCt1WZxSTqZv69bpeY1SPWFOEEg52JMZbY+mgB
         JR6apSuJe1TByecsKq9twoWAJzWVYWyKGbeqA=
MIME-Version: 1.0
Date: Tue, 3 Mar 2009 12:22:18 +0100
Message-ID: <5b9cce670903030322m9a5553fx2aa19f1591833f44@mail.gmail.com>
Subject: memory allocation over 4gb under x86_64
From: protagora27 protagora27 <protagora27@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I have a 64 bit dma that I have to program with 64 bit physical
address
beyond 4 gb because I have to test dma with memory allocation beyond
4 gb.
I 'm using linux x86_64 2.6.24 and I have 8 gb ram.
How can I allocate physical dma memory beyond 4gb ? In x86_64
can I use __pa to have physical address ?
I have used kmalloc giving virtual address : ffff810225d10340
and using __pa i have: 225d10340 that is over 8 gb .
Does it mean that kmalloc return address is not linear mapped with phys ram ?

I would like to find a function that returns a physical adddres beyond
4gb
and then i write phys address in dma register .

Thanks.
