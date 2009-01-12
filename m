Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZALPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZALPvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZALPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:51:15 -0500
Received: from web34408.mail.mud.yahoo.com ([66.163.178.157]:28388 "HELO
	web34408.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751096AbZALPvP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:51:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=teGgoYT/iM461bmEkz3yaHKC3T4Y7AxAWYys7m3GOabf2iRVJqBASCNio3eLSWVNGvLs3fCnklk5IIp97bAKwvadbCWK4jitPyzzPkoz1hHi9iSOZIY4I3oDqoKwLBmbxrxa2pxwMO6bKdwoog69xiVntW6HuN3v/L2XRyOu8gM=;
X-YMail-OSG: Nkz4syYVM1mfjPt8dL.PwWtE4kX64fdKc2gb8Nt1QIkq6Onf0x3fNGKtS3U1W6ghOgrDEa0JoTd61UB_HlaHcZUcuWwhbNoivXNU_VmRizPtOLj5Li29EX80dK.XG1GuLkC2Wk3lr1XDYKxmkD.jUSdESiSr89QgQMMW25TTiuy17u1IDLk4EcYj6shCKOH070w_GvLxwBc_7NhkFyd9uO010sTQOw--
X-Mailer: YahooMailWebService/0.7.260.1
Date: Mon, 12 Jan 2009 07:51:13 -0800 (PST)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Reply-To: joseluismarchetti@yahoo.com.br
Subject: Re: How to access a regular file from within a module ?
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <496AC8D9.1020402@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <113881.9018.qm@web34408.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> One big problem with file access in the kernel is that all
> the file operations require a process context - they need a
> process to stick the file descriptor into, to determine
> access permissions, etc. If you just start calling file
> operations from inside the kernel you're essentially
> stealing whatever process you're being called from's
> context for these operations, which is unlikely to be a good
> idea.
> 
> Not to mention, that accessing files from inside the kernel
> usually means the kernel enforces a policy on file
> naming/locations, and putting that sort of policy in the
> kernel is usually frowned upon.
OK, that is clear now.
>From all I read, it is possible to access files from within inside the kernel, but it would not be a good practice, thanks for the insights.
> 
> In the case you're describing I'm not sure why you
> couldn't just store the keys in encrypted form inside
> the user app and have it write them back out when they
> change, instead of making the kernel do it..
Yes, that was one of the possible solutions I pointed out, and it might be the one I am going to use, thanks!



      Veja quais são os assuntos do momento no Yahoo! +Buscados
http://br.maisbuscados.yahoo.com
