Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0CICJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:09:22 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35877 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0CICJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:09:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CXqU1CCNLw36YvAmz/qHYCThH2832/HBwjaDf+XJ8kc81qFlJvxuHRa0nCONfXcjS2
         GqbCYf2q8uypVyS5kZDXz6/HX98b0DUy+sZ2cei9FvRu6bAimeMY/Qq/4kkGXF1+TLut
         rCTmjdE73GH3vQl7xft9SaUU9ReIMSZS1hMr4=
MIME-Version: 1.0
In-Reply-To: <20100309015518.GS30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <20100308184521.GK30031@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
	 <ff13bc9a1003081718k1e7964f5ta9e582866dea94ee@mail.gmail.com>
	 <20100309012552.GR30031@ZenIV.linux.org.uk>
	 <ff13bc9a1003081751s535fbf71l9d261b303587b23a@mail.gmail.com>
	 <20100309015518.GS30031@ZenIV.linux.org.uk>
Date: Tue, 9 Mar 2010 03:09:11 +0100
Message-ID: <ff13bc9a1003081809x7a4b5828wdcb0a56594a1fb24@mail.gmail.com>
Subject: Re: Upstream first policy
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> <sarcasm>
> Yeah, especially when it's read by sshd.  Who cares, indeed?  So it's got
> a passwordless root, that's even better, right?  Nobody will see your
> real root password that way...
> </sarcasm>

Not sure what you mean exactly.
You won't have a passwordless root if you don't allow anyone to modify
the file at /etc/shadow, or change that dentry by deleting a file
there or putting an arbitrary file there (with creat, rename or link).
This is conceptually a path-based security check.

It is also separate from the problem of not giving anyone knowledge of
the root password or hash of it, which a conceptually content-based
security check on reads.
