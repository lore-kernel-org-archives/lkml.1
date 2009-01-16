Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbZAPIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbZAPIsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZAPIsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:48:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:45020 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZAPIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:47:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=u4SLEPoCyCeatLDAzSQLC9gtOWfQdYU3/AptNR5hKSKHvK/0dfPIHtUxafF+srlh0o
         D2jcfD0LJ4K37wAToloP6vBkX1N8JeN/pfg0fRDdeNfQijf3XWKXpc48eYqE7ycRvx82
         f8HHUavUyG3rv6ceIOpalttKz4UPACvbZHFg0=
Message-ID: <497049B9.50104@gmail.com>
Date: Fri, 16 Jan 2009 09:47:53 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 81/85] x86: fix RIP printout in early_idt_handler
References: <20090115215237.906089480@mini.kroah.org>	 <20090115215812.GA17227@kroah.com> <20090115220204.GD17227@kroah.com> <df9815e70901151927i29b0da1fh168c80cd80b754ae@mail.gmail.com>
In-Reply-To: <df9815e70901151927i29b0da1fh168c80cd80b754ae@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2009 04:27 AM, Jike Song wrote:
> why not:
> 
>     movq (%rsp), %rsi
> 
> instead? Yes, it's all the same but 0 is just unnecessary.

To be consistent with the rest of the file. Feel free to post a cleanup patch
for the whole file to see what maintainers think ;).
