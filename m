Return-Path: <linux-kernel-owner+w=401wt.eu-S939295AbXGSPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939295AbXGSPcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbXGSPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:32:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:30262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514AbXGSPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pMJbFZgS8GJypvjUCaYCbqUgJ0qsgbGao4/w1pApCeBegaJ1icgTj0xzILEbG9/gVReySpSxW5vrHdibsSDqEE5dKY5iLklWzOljhBlS4wmdjha901Wk/ipAWqVPideCGnU1eQUFi9QPTey5zC4VzZ6bNg0aGCao32wU4YjV1F0=
Message-ID: <469F8417.5020008@gmail.com>
Date: Thu, 19 Jul 2007 17:32:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, Karel Zak <kzak@redhat.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] Delete export of tty.h to userspace.
References: <Pine.LNX.4.64.0707180520040.19434@localhost.localdomain> <469E7599.4060608@gmail.com> <Pine.LNX.4.64.0707181631340.14452@localhost.localdomain> <20070718223820.GF3181@petra.dvoda.cz> <Pine.LNX.4.64.0707190715320.25024@localhost.localdomain> <20070719135707.GA16279@infradead.org>
In-Reply-To: <20070719135707.GA16279@infradead.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig napsal(a):
> On Thu, Jul 19, 2007 at 07:17:07AM -0400, Robert P. J. Day wrote:
>> so you're saying you'll drop that include from util-linux, is that it?
>> but it's still a good plan to generate a warning whenever userspace
>> includes that file, so i'll submit a quick patch to generate that,
>> based on jiri's suggestion.
> 
> Not exporting it at all gives an error which is a lot better.  Just look
> at all the warnings most userspace spews, they'd never even notice it
> otherwise.

Not directly responding to this, but keeping CCs. I though of the removal one
more time and there is one more issue (maybe). Every exported kernel header,
which includes this file outside #ifdef __KERNEL__ #endif will be broken in
userspace. Are you sure, there are no such includes?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
