Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZF2JnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZF2JnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZF2JnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:43:08 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46834 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZF2JnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G6pMTBVQGc8ZtrzLOL3282rhluBswJclwD4YRcOmeM2EUXtFvFvAno0pAp7Slcacb/
         oFjp+lZ5Uv+ozUeQZTEZBwAG7siJMeqFXB8SQmRkYxBSmpPdJyg+Q00oB4JOjDyYkDAe
         zyY+4SL7so96ExyjTtj2+thT0Y4FXAiXh5n1g=
MIME-Version: 1.0
In-Reply-To: <20090628173632.GA3890@localdomain.by>
References: <20090628173632.GA3890@localdomain.by>
Date: Mon, 29 Jun 2009 12:43:09 +0300
X-Google-Sender-Auth: d19bda014ba10dc6
Message-ID: <84144f020906290243u7a362465p6b1f566257fa3239@mail.gmail.com>
Subject: Re: kmemleak hexdump proposal
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergey,

On Sun, Jun 28, 2009 at 8:36 PM, Sergey
Senozhatsky<sergey.senozhatsky@mail.by> wrote:
> What do you think about ability to 'watch' leaked region? (hex + ascii).
> (done via lib/hexdump.c)

What's your use case for this? I'm usually more interested in the
stack trace when there's a memory leak.

                        Pekka
