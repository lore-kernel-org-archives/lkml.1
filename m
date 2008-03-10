Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYCJWbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYCJWbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbYCJWai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:30:38 -0400
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:45606 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757554AbYCJWah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:30:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jj6EY2o8iJYZUJ5ZmFMeDlkcbweK8ybUxjdoK2Ueun9yF95rlGnUi3vZIL1Tg71NqlG9n4Yeu4npfe486FRUoNMnhaAls06ZitX85UxkzW5wuv2B1wNeF1wI2Bt9VTutIR7KpTNjK2ZrB7mOSOzKmlKlns5P/FBjMPyX5NY+etM=;
X-YMail-OSG: YkCdVh0VM1lxW7q9GX4b8ShIxrorVT2KkIKLoIOX1ED9uavYA5JedkpvstbFAnr7D7fYjmssuOXqFuyR9rtyhlryVFQkBqnBYykdlzQEhMgyrGNPzTs-
Date: Mon, 10 Mar 2008 15:30:35 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: What does a Kernel Error 4 mean?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47D0E0D4.408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <984174.19414.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "H. Peter Anvin" <hpa@zytor.com> wrote:

> Marc Perkel wrote:
> > What does a Kernel Error 4 mean? I'm getting this
> > running 64 bit Exim. Just trying to track it down
> and
> > wondering what an "Error 4" is?
> 
> Probably:
> 
> #define EINTR            4      /* Interrupted
> system call */
> 
> EINTR should be a non-fatal error; the fact that
> Exim reports it as an 
> error probably indicates an Exim bug.
> 
> Of course, it could mean something completely
> different.
> 
> 	

Thanks - I'll look into it further.


Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
