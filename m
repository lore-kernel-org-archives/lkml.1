Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZH1ToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZH1ToZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZH1ToY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:44:24 -0400
Received: from web45211.mail.sp1.yahoo.com ([68.180.197.140]:48285 "HELO
	web45211.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752645AbZH1ToY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:44:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=x20GCF9P8lCMS5uUb6GGSO41p+V130mNx5R1KomGcOFe7GgsVBytl07BIyMbh3mYFLi0OVdM5qajR23jMd+6hUSnqWHM60RtV9wR97giLmEvhld9LmdGmgYvAZHM8wzwcGum+xgtK0Nz7Eh61rUdsuwZX4ii4u5TytaW8qJ07c4=;
Message-ID: <8980.20135.qm@web45211.mail.sp1.yahoo.com>
X-YMail-OSG: cZAdacMVM1mtyMv76y.yfhyqoB0jj_jL0EaQUpbL04zgf1UgLYTfEUZ9yfzFNrfSazh7Dc_VGFL3RXDaNst9ZhlJ0oQmRpGpQpGLS5bgjql0YKf0.wDgU9LIgeN8Wz9KioEe64B2tePGQPzRJgnkbDG9rPsCzgLdnv3id8sKKseymg7secOmlkpE6XR0QYThWSRgzsGcj0DrChuwJnw-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 28 Aug 2009 12:44:25 -0700 (PDT)
From: joe Shmoe <jsmoe3@yahoo.com>
Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <24089.1251486780@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No I am not talking about embedded systems. It is just an example.
My question is what is preventing the kernel from setting up the page tables so that entire RAM can be mapped upto 4 GB.

page tables have to be setup for every process anyway with first 768 PDE entries being unique and remaining 256 entries being same for all the processes.


--- On Fri, 8/28/09, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> From: Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu>
> Subject: Re: kernel page table mapping for >1GB <3 GB for x86 arch without PAE
> To: "joe Shmoe" <jsmoe3@yahoo.com>
> Cc: "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org
> Date: Friday, August 28, 2009, 3:13 PM
> On Fri, 28 Aug 2009 11:40:56 PDT, joe
> Shmoe said:
> 
> > For the sake of discussion, let us say I have 3.5 GB
> of RAM of x86 with PAE
> > disabled and I have only one process running other
> than kernel.
> 
> Oh, so an embedded environment. Sure, you could play games
> with that.
> 
> But most Linux systems have more processes running than
> just 'init'. And
> in that case, what do you do with your memory map?  It
> gets a bit more
> complicated then....
> 
> 


      
