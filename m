Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbZCJO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbZCJO3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZCJO3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:29:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:41492 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZCJO3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uT9O3oeZoDa95ST7RlbV7iw99wkavrFuF4EhRKhGsAXfyJKtPzNv84eZKOgDYHkPXd
         tcjNNZHz46ptrgREEY5ouC++DgxHSgf3zRjEIiT2rgKi3JkI4xa4a9Vp+kCMj8tXHZ6Z
         /4uL/PpbYw45iZl37rKxhUinrKw8FXBhToCj0=
Date: Tue, 10 Mar 2009 22:29:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Rob Landley <rob@landley.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
Message-ID: <20090310142929.GG3157@hack>
References: <200903060042.19084.rob@landley.net> <20090306084848.GO22605@hack.private> <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com> <10f740e80903060151w779bbd11ld2fcc437ac7ac321@mail.gmail.com> <20090306111834.GC8991@hack.private> <20090306143543.GA6983@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306143543.GA6983@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:35:43AM -0500, Jeff Dike wrote:
>On Fri, Mar 06, 2009 at 07:18:34PM +0800, Am??rico Wang wrote:
>> It does work well x86_64, but my question is that whether this will
>> break i386 or not, since before, CONFIG_3_LEVEL_PGTABLES depends on
>> EXPERIMENTAL on i386, this patch removes it.
>
>As long as CONFIG_3_LEVEL_PGTABLES is off on 32-bit, it should be fine.
>
>It did work, last I checked, but 3-level page tables on 32-bit is a
>very rarely used combination, and not useful.
>

So this patch should be fine, right? :)

Thanks for your comments!

-- 
Do what you love, f**k the rest! F**k the regulations!
 
