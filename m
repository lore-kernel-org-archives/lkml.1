Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYCWPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYCWPqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYCWPq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 11:46:29 -0400
Received: from n67.bullet.mail.sp1.yahoo.com ([98.136.44.47]:32300 "HELO
	n67.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751649AbYCWPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 11:46:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 536368.68575.bm@omp404.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=akRVN6G12F/Hyk1GvoNfGUyrLWFHMwld+z6J/wvY1clbtA0YyrxSSt9yqYCHpv9N/9fGN6m02N00s9PI9BNOnECotelwPXofKSMRQMUfH0LW8guO9HoBZkcpgciYVQKx6qrM0Qq+IOcJiESVP6+pMzikHrvS2puxmqN4whFNRak=;
X-YMail-OSG: 4vsNwqEVM1nswM9ZBkj0970mAFk40igEN5q01lo4D2lZVAIOe6Z5bAgNUnxWjNesFJUHBTIpRfFyesgaH.7yKdN2tw--
Date: Sun, 23 Mar 2008 08:46:28 -0700 (PDT)
From: "John T." <j.thomast@yahoo.com>
Subject: Re: UTF-8 and Alt key in the console
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.00.0803231627430.3157@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <349800.20247.qm@web45701.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Sunday 2008-03-23 16:15, John T. wrote:
> >
> > It is understood that although the Meta-key sequences
> > work in an xterm with vim on UTF-8, they don't on the
> > linux console.
> 
> They also seem work on the console; I can use Alt-L in
> mcedit to jump to a line.
> 

That's because you are working in "meta sends ESC" mode.
Although this is OK for most applications, for some it isn't.
Thus there have always been two modes, "meta sends ESC"
and "meta sets 8th bit". (toggled with setmetamode on the
console)

Vim relies on "meta sets 8th bit". Unfortunatelly the code
for this options does not work in UTF-8 in the console. What
I'd like to do is make this a viable option in UTF-8.


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

