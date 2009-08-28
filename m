Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZH1SIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZH1SIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZH1SII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:08:08 -0400
Received: from web45210.mail.sp1.yahoo.com ([68.180.197.131]:38073 "HELO
	web45210.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751125AbZH1SII convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:08:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GmYOSpgxD0qn63pbTwfDRtrXZBkKeNydOLipdgXHw3PfAw4YYS/9Em1JmFMwuHzYQrUe46gcKlRfCm5z9uIRz2x18+gy6BauwLOy+PYsl8qnVetJ2qRvjNjrxkuhIn4n7WrkwE61PPpKqjVKa7qHSsU62pvX9xhmLiupNNfhFX8=;
Message-ID: <374672.36063.qm@web45210.mail.sp1.yahoo.com>
X-YMail-OSG: OL2ce6MVM1mtMQwYjgL3yTrTjo1Jx6o0Ql27AwYYUi0b1w98DfjA6D9938UYjI7qdNiPQ7XFep3B0poxUCuSY8NIzMSube3F2kcdJUPIDHzoncdbsejHc.3T5o6gjs.x4vH1Mye.exFkaJa49rH1Ou5_ypfns2Fl68ILwBXuV6eDXCTVgsInXiwMhOExRbjyYpO0KBJU1.f.CwGsGA--
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 11:08:08 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: kernel page table mapping for >1GB <3 GB for x86 arch without PAE 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming I have 3GB RAM, why does not kernel create page tables in a way that all of this 3GB physical memory can be addressed . (for x86 arch 32 bit with PAE disabled )

I understand the 3GB/1GB split for user/kernel address space.Isn't  this just a matter of setting up the page table entries in such a way that so all the available RAM upto 3GB can mapped in the kernel page tables. In this way CPU's MMU can take care of mapping any virtual address within first 4GB to physical address using the page table entries regardless of a process is in kernel/user mode. 

Why can't some of first 768 page directory entries ( + 1024 page table 
entries for each PDE) be used to map btw 1GB and 3GB. What is stopping the kernel from doing this?

Instead why does kernel uses high memory mapping with zone model for 
addressing physical memory above 1GB?

Can anyone please shed some light into this,


Thanks,


      
