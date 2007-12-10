Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbXLJDUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbXLJDUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXLJDU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:20:29 -0500
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:34911 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754472AbXLJDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:20:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=kvvhFhlNR3eVYux9F/XyX+chIn6zt6KYkK6A86K9ED6gRH0fM5j+h+3ZtN5BOEp2imME92XoFvO1s27V9CL3AEqkH3oYz3S7pkNg0JoNk/pIopJDOu+3iTHUiDjPyz4npKZSbcJJGUfrd1iUhKIJHHUwXvOjUzD87RlyPllsZ/g=;
X-YMail-OSG: J6UpTLUVM1nWM2Vs1_Ry1D7jnsCEhqJhjVyajrvUm0rbOnq_2NZO4Lrz32CcbOqFX4fkv7a8dwt1cCDp4YvgB2RipS1aYKWzAbjyTzry2FsuSof2f5ENtuUYiLojkg--
Date: Mon, 10 Dec 2007 03:20:26 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209143237.1e608d9f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <39522.31806.qm@web52904.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Arjan van de Ven <arjan@infradead.org> wrote:
> the memory you feed to readl() and co isnt the actual PCI resource;
> you need to use ioremap() on the PCI resource to get a pointer that you can then feed to
> readl()....

I gathered that much, and there is indeed a call to ioremap() in the code. So are you suggesting
that  I try replacing that ioremap() call with ioremap_nocache()?

Cheers,
Chris


      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
