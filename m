Return-Path: <linux-kernel-owner+w=401wt.eu-S936523AbXGMOmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936523AbXGMOmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXGMOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:42:07 -0400
Received: from web26913.mail.ukl.yahoo.com ([217.146.177.80]:27361 "HELO
	web26913.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932099AbXGMOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:42:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XA6eY2hLb83k7OsJGoBHvHIsYLUQQWmOYB0x8xtCtiklI/GmhIz6/qukDRT5thu55MSjgk55J9F1jA3rvTut1jY3jvAJ6CjUGfWjl6Yw8JePxLDBZWYxGONEVcV3gEmGKEMGHRGG7EXpVcydjCU/pXBJKWlBC2EvMfvmBF+iYrI=;
X-YMail-OSG: 1iT1M9kVM1nzz9XY0GIlJY6EvMaBokHuCIPal2uv157U0jT0AxGVu9Q1CTj7S.Mdkg--
Date: Fri, 13 Jul 2007 16:42:02 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: x86 setup code rewrite in C - revised
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <590581.39283.qm@web26913.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi wrote:
> The only thing questionable is that .code16gcc is arguably quite
> an abuse of gcc. I even checked with some gcc developers 
> and they weren't too happy about it. e.g. it's not regression
> tested at all so we would be basically on our own with it.

 On the other hand GCC just produces an assembly text file, it is
not the GCC developper problem what the user does with this text file.
Usually it goes to the assembler with standard options - .code16gcc
is a "special" option - and bugs (if there is) should be forwarded to binutils.
 GCC tries to go around CPU bugs, and those bug may be different in
protected or real mode - but I still do not have one example of such
a bug.
 GCC also has a base library support (multiplication & divisions of
64 bits...), and when you use .code16gcc you know you cannot touch it
(it is assembled with .code32); so that management may be what they
are refering to.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
