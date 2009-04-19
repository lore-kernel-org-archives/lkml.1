Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZDSO1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZDSO1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbZDSO1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:27:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:46716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbZDSO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:27:37 -0400
Date: Sun, 19 Apr 2009 07:29:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Task Struct From Hell <taskstructfromhell@googlemail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: how to build a vmlinux with debugging symbols?
Message-ID: <20090419072934.592127af@infradead.org>
In-Reply-To: <ef37ea20904190718p2d5164efib231cc9f468854c2@mail.gmail.com>
References: <ef37ea20904190718p2d5164efib231cc9f468854c2@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 15:18:33 +0100
Task Struct From Hell <taskstructfromhell@googlemail.com> wrote:

> List,
> 
> I am trying to figure out why one of my servers crashed, I have some C
> and ASM knowledge and back in the 2.2 days I even wrote a few modules
> to the Linux kernel, but now I am completely lost in the 2.6 kbuild
> and as such, can someone point into some documentation on debugging
> vmcore's and how to enable debugging symbols so using gdb wont be as
> painful? :-)

Hi,

just enable CONFIG_DEBUG_INFO configure option...

(and you can use the sripts/markup_oops.pl script to help decode
oopses.. no need for gdb)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
