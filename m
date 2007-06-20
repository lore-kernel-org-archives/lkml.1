Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbXFTHc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbXFTHc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757753AbXFTHcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:32:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:8106 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbXFTHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Xf77Uh1T9RNR4FJjIkwKtZfOYXA923S2gUblJKc3RuyAf9jgyfAHrf1oKsYYMI38qli1hS4JHCshaJni0GuLTo9JgS0M2nkqeptRYqBuymmmG2cbGyT6wzNsC1rinrcOYlIq7F6DmywOuGd8K09OWFeRT6m5JkjLjd/F1aLe21Y=
Message-ID: <4678D808.6030804@gmail.com>
Date: Wed, 20 Jun 2007 09:32:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Shaun Savage <savages@savages.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How do you allocate huge pages.
References: <4677C702.6050102@savages.net> <20070619123803.GD22468@traven>
In-Reply-To: <20070619123803.GD22468@traven>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Kaehlcke napsal(a):
> El Tue, Jun 19, 2007 at 05:07:30AM -0700 Shaun Savage ha dit:
>  
>> I am trying to allocate very large memory within the kernel. I want to
>> start by allocating one huge (4M) page and using that as buffer space.
> 
> possibly vmalloc() is what you're looking for, if it isn't really a
> *page* of 4M, what afaik is impossible with a standard kernel.

sparc64 can have pages up to 4M in size. This changes nothing in the fact, that
you should use vmalloc for such big spaces. Esp. when you allocate it after some
time from boot, otherwise fragmentation disallows you to alloc physically
contiguous memory due to fragmentation.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
