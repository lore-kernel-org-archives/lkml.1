Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXLWT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXLWT6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbXLWT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 14:57:53 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:55776 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbXLWT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 14:57:52 -0500
Date: Sun, 23 Dec 2007 21:57:48 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Morer verizon problems
Message-ID: <20071223195748.GK28168@mea-ext.zmailer.org>
References: <200712231410.39491.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712231410.39491.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 02:10:39PM -0500, Gene Heskett wrote:
> Date: Sun, 23 Dec 2007 14:10:39 -0500
> From: Gene Heskett <gene.heskett@gmail.com>
> Subject: Morer verizon problems
> To: linux-kernel@vger.kernel.org
> 
> Just for a heads up, for about the last 8 hours, verizon, my ISP, has been
> inserting themselves into the path between my gmail account and my local
> fetchmail of this email subcription at pop.gmail.com.

Gene,

The Received: header data are telling something else.
You read them from bottom-most up -- new one is always inserted on top of
the existing headers.

   Received: by nz-out-0506.google.com with SMTP id x7so90741nzc.3 for
     <gene.heskett@verizononline.net>; Thu, 20 Dec 2007 18:08:08 -0800 (PST)

It does look like you have a forwarding setting at gmail to your
verizononline.net service.  If you had chosen to pull email out of
gmail, then perhaps you would not have had any verizon problems.

While conspiracy mongering has its fun, I do think that you are in fact
causing this all to yourself by trying to push the message flood to
Verizon..  For what it matters - LKML has 3 subscribers on  @verizon.net
addresses.

I do run my own mail-server, and my Linux mailboxes are at present over
1 GB/y.  Gmail mailbox would be a bit larger - underlying database
granularity is around 128 or 256 kB, as I recall having read about
google technology.


> Worse yet they are bouncing the messages in a way that makes it look as if I
> sent them when they in fact originated at vger.kernel.org.  Somehow they have 
> convinced themselves that any mailing list this busy must be spam and is to be 
> bounced.  Either that or they, verizon, since they sleep with M$, have taken a 
> large under the table payment to screw with linux in any way they can.  It 
> bears investigating.
> 
> I called just now and screamed bloody murder at tech support, and in about 15 
> minutes I started getting the list again, BUT they are still in the path 
> between vger and my fetchmail daemon as shown below.

Yes, I would fetch directly from gmail, if I were you...

        /Matti Aarnio   --   one of   <postmaster at vger.kernel.org>

> Or at least that is how I am interpreting the incoming headers, which now look 
> like this by the time they hit my inbox but with my SA headers clipped:
> -----------------------
>  Received: from incoming.verizon.net [206.46.232.10]
>         by coyote.coyote.den with POP3 (fetchmail-6.3.6)
>         for <gene@localhost> (single-drop); Thu, 20 Dec 2007 21:10:08 -0500 (EST)
>  Received: from mailbag1.bizmailsrvcs.net ([172.18.12.131])
>   by vms051.mailsrvcs.net
>   (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
>   with ESMTP id <0JTD00L5XN9KBGD0@vms051.mailsrvcs.net> for
>   gene.heskett@verizon.net; Thu, 20 Dec 2007 20:08:11 -0600 (CST)
>  Received: from [64.233.162.238] (port=3333 helo=nz-out-0506.google.com)
>   by mailbag1.bizmailsrvcs.net with esmtp (Exim 4.68)
>   (envelope-from <gene.heskett+caf_=gene.heskett=verizononline.net@gmail.com>)
>   id 1J5XG9-00052G-Du    for gene.heskett@verizononline.net; Thu,
>   20 Dec 2007 20:05:09 -0600
>  Received: by nz-out-0506.google.com with SMTP id x7so90741nzc.3 for
>   <gene.heskett@verizononline.net>; Thu, 20 Dec 2007 18:08:08 -0800 (PST)
>  Received: by 10.142.132.2 with SMTP id f2mr436687wfd.221.1198202887677; Thu,
>   20 Dec 2007 18:08:07 -0800 (PST)
>  Received: by 10.142.222.3 with SMTP id u3cs177296wfg; Thu,
>   20 Dec 2007 18:08:07 -0800 (PST)
>  Received: by 10.100.202.9 with SMTP id z9mr1420295anf.42.1198202883749; Thu,
>   20 Dec 2007 18:08:03 -0800 (PST)
>  Received: from vger.kernel.org (vger.kernel.org [209.132.176.167])
>   by mx.google.com with ESMTP id q26si917844ele.6.2007.12.20.18.07.38; Thu,
>   20 Dec 2007 18:08:03 -0800 (PST)
>  Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand   id
>   S1759056AbXLUCHP (ORCPT <rfc822;wyh817@gmail.com> + 49 others); Thu,
>   20 Dec 2007 21:07:15 -0500
>  Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXLUB7V
>   (ORCPT <rfc822;linux-kernel-outgoing>); Thu, 20 Dec 2007 20:59:21 -0500
>  Received: from smtp.polymtl.ca
>   ([132.207.4.11]:53375 "EHLO smtp.polymtl.ca"   rhost-flags-OK-OK-OK-OK)
>   by vger.kernel.org with ESMTP  id S1761264AbXLUB7M
>   (ORCPT <rfc822;linux-kernel@vger.kernel.org>); Thu, 20 Dec 2007 20:59:12 -0500
>  Received: from dijkstra.casi.polymtl.ca
>   (dijkstra.casi.polymtl.ca [132.207.72.10])     by smtp.polymtl.ca (8.13.8/8.13.8)
>   with ESMTP id lBL1vVHB024689
>   (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT); Thu,
>   20 Dec 2007 20:57:32 -0500
>  Received: from compudj by dijkstra.casi.polymtl.ca with local (Exim 4.63)
>   (envelope-from <mathieu.desnoyers@polymtl.ca>) id 1J5X8g-00040X-Gt; Thu,
>   20 Dec 2007 20:57:26 -0500
>  Date: Thu, 20 Dec 2007 20:54:50 -0500
>  From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>  Subject: [patch 12/24] Immediate Values - Architecture Independent Code
>  X-Originating-IP: [172.18.12.131]
>  Sender: linux-kernel-owner@vger.kernel.org
>  To: akpm@linux-foundation.org,
>  Ingo Molnar <mingo@elte.hu>,
>  linux-kernel@vger.kernel.org
>  Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
>  Rusty Russell <rusty@rustcorp.com.au>
>  Message-id: <20071221015726.253261266@polymtl.ca>
>  X-Forwarded-for: gene.heskett@gmail.com gene.heskett@verizononline.net
>  Content-disposition: inline;
>  filename=immediate-values-architecture-independent-code.patch
>  Precedence: bulk
>  Delivered-to: gene.heskett@gmail.com
>  Received-SPF: pass (google.com: best guess record for domain of
>  linux-kernel-owner@vger.kernel.org designates 209.132.176.167 as permitted
>  sender) client-ip=209.132.176.167;
>  Authentication-Results: mx.google.com; spf=pass (google.com: best guess record
>  for domain of linux-kernel-owner@vger.kernel.org designates 209.132.176.167 as
>  permitted sender) smtp.mail=linux-kernel-owner@vger.kernel.org
>  X-Forwarded-To: gene.heskett@verizononline.net
>  X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri,
>  21 Dec 2007 01:57:31 +0000
>  References: <20071221015438.433195466@polymtl.ca>
>  X-Mailing-List: linux-kernel@vger.kernel.org
>  List-Id: <linux-kernel.vger.kernel.org>
>  User-Agent: quilt/0.46-1
>  X-procmail: user=gene
>  Status: RO
>  X-Status: UC
>  X-KMail-EncryptionState: 
>  X-KMail-SignatureState: 
>  X-KMail-MDN-Sent: 
> 
> Any mail experts here want to debunk my findings, jump right in, I'm not an
> email guru, but it sure looks to me as if they are rerouting ANY port 25
> access through their servers now.  And M$ would pay millions to screw us,
> and has, its a matter of record.
> 
> -- 
> Cheers, Gene
> "There are four boxes to be used in defense of liberty:
>  soap, ballot, jury, and ammo. Please use in that order."
> -Ed Howdershelt (Author)
> Lo!  Men have become the tool of their tools.
> 		-- Henry David Thoreau
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
