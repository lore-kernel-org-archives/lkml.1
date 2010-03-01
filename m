Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0CASrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:47:06 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43379 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0CASrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f3yHLkutGOhsMfGBaVhqaibmsnI+djXwxf7g8x/G/3R1uqgW3aDjH4ZSyCPrxTypwz
         6Mej+jaZn0uDL9O97qPcDt1r4jFGsh8OUXLmhgQAtR4Hy/F2ETZYCzOG3V82ut4DFtre
         4zK7b1mbmj7quM0HhdghN98FWMvc/AhNWb42g=
MIME-Version: 1.0
In-Reply-To: <4B8C09F5.9070506@redhat.com>
References: <20100301091819.GD16909@redhat.com> <4B8BE7C1.40000@redhat.com>
	 <20100301174724.GA12867@redhat.com> <4B8C09F5.9070506@redhat.com>
Date: Mon, 1 Mar 2010 19:47:00 +0100
Message-ID: <ff13bc9a1003011047i430ee89fi49a3154b87e127ef@mail.gmail.com>
Subject: Re: use of setjmp/longjmp in x86 emulator.
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about an interface that works like setjmp/longjmp, but requires to
pass a function pointer to setjmp, which calls that function, and
allows longjmp to work in that function only?

This avoids all concerns about local variables and should be cleaner,
faster and simpler to implement.
