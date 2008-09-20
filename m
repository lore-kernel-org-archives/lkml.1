Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbYITOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbYITOax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYITOao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 10:30:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:54774 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYITOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 10:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vqwBV4z/BCv58djbC8+2wGuMUhyrymYRhUgJ3l/+Q8Ug+d4WFJT2BRBj/A0WJhLLEr
         ORMshZAcSH0ySYyAS77lGdqMc1srMmJMg/XfxmeB2zrMOFvuZATRFm/b8bXtQTpz6haG
         oqJN2Q+x98o/huXDQ5E/v9v3rayjd4seY0kjU=
Message-ID: <cabda6420809200730u4b2f47e7i4ba811fce09aff17@mail.gmail.com>
Date: Sat, 20 Sep 2008 16:30:40 +0200
From: chri <chripell@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] max3100 driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
In-Reply-To: <20080920065652.11d76780@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221895208650-git-send-email-chripell@gmail.com>
	 <20080920012454.e40f03cc.akpm@linux-foundation.org>
	 <20080920065652.11d76780@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 3:56 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>
> I do have a question though: what does a signed bitfield of 1 mean?
> I mean.. the variables are "int", so signed.... where will the compiler
> store the sign bit???
>
>

In practice they stored just values 0 and 1 well. 2-complement
representation with 1 bit doesn't have much more space (1 == -1). :-)

Anyway after Andrew comment I stopped using them since I'm too scared:
I'm not sure that it's safe without locking the entire struct.

-- 
Christian Pellegrin, see http://www.evolware.org/chri/
"Real Programmers don't play tennis, or any other sport which requires
you to change clothes. Mountain climbing is OK, and Real Programmers
wear their climbing boots to work in case a mountain should suddenly
spring up in the middle of the computer room."
