Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXEIN42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXEIN42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXEIN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:56:15 -0400
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:35040 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754776AbXEIN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:56:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=hz61D07Qk+rE/Uk/gGIBxu1qbhx9DKrEfPX8wkxfc6R+5QwvdjVFG/QPSv3dQK8QEBTpxBPelXDbxnC6yyequEOZfKvGJA3UTDoJNOOUBLutWsM9I0mcREgeN00ZEMq4DUFZR1pEpOWGK34nKJ12kxQv7JjleTL8QG82iTkmSbQ=;
X-YMail-OSG: 2l9HtL8VM1n6caJKcRUwnX8c7lg3MeXk7Ifu2uq6NCl1aD64fk6HoD.ThUV2LDRVtHvRX1iw4Vii.p5dO76Im0Yw3Yyzzf3l.AUQgbT.Xc4D9F2M3kBwAkZb2gL2oHW8r3eRjl1Xhw--
Date: Wed, 9 May 2007 14:56:13 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel bug 8198)
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>
In-Reply-To: <4641CD01.6010309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <691707.19263.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Okay, here's a half-assed fix.  With this patch applied, if you try to
> unload a module while you're opening it's dev attribute, kernel will
> oops later when the file is accessed or closed later but it should fix
> the bug winecfg triggers.  I really dunno how to fix this the right way
> in the stable kernel.  Better ideas?  Anyone?

How about a WARN() and a small(?) memory leak? Better than an oops, surely?

Cheers,
Chris



      ___________________________________________________________ 
Yahoo! Mail is the world's favourite email. Don't settle for less, sign up for
your free account today http://uk.rd.yahoo.com/evt=44106/*http://uk.docs.yahoo.com/mail/winter07.html
