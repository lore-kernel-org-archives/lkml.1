Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYBIPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYBIPlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYBIPlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:41:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:27264 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYBIPlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=B5s+enUjfk61JuNvrw82QY9/YCtMhVLVhW4vJP3UyJ5ueJgWdi5qkj8h1bHJy9UEBU8Oy8liB+PojI12pOeoko0Ra/GQx9R2aeRJnimqIJwgfs8pxMBf9QjXEyZPMZxaq+1cgruL580H/op/c1PhC159bMLSk3LzuA1oFSbONMM=
Message-ID: <84144f020802090741k6fe3324cu99d70f13d9fd54ec@mail.gmail.com>
Date: Sat, 9 Feb 2008 17:41:00 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christer Weinigel" <christer@weinigel.se>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>,
       "David Newall" <davidn@davidnewall.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Diego Zuccato" <diego@otello.alma.unibo.it>,
       "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080209161322.6ccd9d4d@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080125180232.GA4613@kroah.com>
	 <20080206213449.6614efea@weinigel.se>
	 <20080206215442.63c94cf3@dilbert.local>
	 <47AB056E.70802@davidnewall.com>
	 <20080207150612.21ba60df@dilbert.local>
	 <47AB163C.5070107@davidnewall.com>
	 <20080207171322.40eb7c95@dilbert.local>
	 <47AB36D2.5050602@davidnewall.com>
	 <20080207184939.17030887@dilbert.local>
	 <20080209161322.6ccd9d4d@weinigel.se>
X-Google-Sender-Auth: 79d5c73ace9a0a75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 5:13 PM, Christer Weinigel <christer@weinigel.se> wrote:
> But lets say that the b-tree code uses Linux-only primitives such as
> kmalloc or spinlocks, and that I wrote the code specifically for the
> Linux kernel, does that make it into a derivative work?
>
> What if I do a trivial replace of the kmalloc calls with malloc and the
> spinlock calls with pthread locks instead, has my code been forever
> tainted by being written for Linux so that I can't do that anymore?
> What if I go the other way and write my code using the posix functions
> to begin with and do the equally trivial replace of malloc with
> kmalloc?

As the copyright owner, you're free to distribute the original parts
as you wish as long as it doesn't contain anything that is derived
work. So, when you remove those kmalloc/spin_lock calls, you're
_obviously not_ tainted. But that doesn't mean you're free to
distribute it when it _does_ contain derived work. Besides, a device
driver can't even be compared to something as trivial as b-tree
implementation that uses kmalloc/spin_lock in terms of "is it derived
work or not."

Thanks for the straw man, though!
