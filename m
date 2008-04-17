Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbYDQJba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbYDQJba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763410AbYDQJL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:56 -0400
Received: from web36701.mail.mud.yahoo.com ([209.191.85.35]:38805 "HELO
	web36701.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763771AbYDQJLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qhfwmu3ZiO+ZDW/mtH5qwT4R6JQO6psVjPq8XWWnsTYBxoitI8H6tj7YCKjnp2lH+MZVvgzjvzRWwYL4DMD5yNEVDseDU4RbLbgWQeDneCIUMqjV0nSh3HKdaXlU8p952L9uPGKR6KMKy6hzZ8BAXWt3IL1SGZ0wZb/sXUmiEhQ=;
X-YMail-OSG: x24cSxEVM1n8oDle9NkeTvsBdl4ejGcOZLrblRdaEukyfZRf3Gd2M0kMjx04aekKGzpvzRyDlqH1nNPbwqv4_l3r3O2qY1hHtNN2dVuvgBE7MShKxbPmCVwWyw--
Date: Thu, 17 Apr 2008 02:11:38 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: Ben Dooks <ben@fluff.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080417090137.GB16284@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <257448.48285.qm@web36701.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Ben Dooks <ben@fluff.org> wrote:

> On Thu, Apr 17, 2008 at 01:50:33AM -0700, Alex Dubov wrote:
> > I've implemented, with generous help from JMicron, a native support for Smartmedia/xD picture
> card
> > media. Currently, only JMicron backend is available, but TI expressed some interest in this
> too,
> > so TI Flashmedia backend may soon follow.
> > 
> > Smartmedia cards are quite akin to the dumb flash chips, but they have their quirks that put
> them
> > aside as a separate media type.
> 
> They're NAND chips, just with a standard ECC/block replacement
> stratergy... why isn't this under drivers/mtd ?
> 

They have nothing to do with JFFS or UBI (it's an interchange format).
They require FTL.
On the other hand, "SmartMedia reader" is a rather definite kind of animal that exists on its own.




      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
