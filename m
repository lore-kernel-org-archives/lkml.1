Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXL0DYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXL0DYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 22:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXL0DYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 22:24:47 -0500
Received: from mail.tmr.com ([64.65.253.246]:33871 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbXL0DYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 22:24:46 -0500
Message-ID: <47731FCA.9090201@tmr.com>
Date: Wed, 26 Dec 2007 22:45:14 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: More verizon problems
References: <200712231430.50493.gene.heskett@gmail.com>
In-Reply-To: <200712231430.50493.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Resend, with more odd data from fetchmail.log appended.
> 
> Just for a heads up, for about the last 8 hours, verizon, my ISP, has been 
> inserting themselves into the path between my gmail account and my local 
> fetchmail of this email subcription at pop.gmail.com.
> 
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
> 
> Or at least that is how I am interpreting the incoming headers, which now look 
> like this by the time they hit my inbox but with my SA headers clipped:
> -----------------------
> Received: from incoming.verizon.net [206.46.232.10]
>         by coyote.coyote.den with POP3 (fetchmail-6.3.6)
>         for <gene@localhost> (single-drop); Thu, 20 Dec 2007 21:10:08 -0500 
> (EST)
>  Received: from mailbag1.bizmailsrvcs.net ([172.18.12.131])
>  by vms051.mailsrvcs.net
>  (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
>  with ESMTP id <0JTD00L5XN9KBGD0@vms051.mailsrvcs.net> for
>  gene.heskett@verizon.net; Thu, 20 Dec 2007 20:08:11 -0600 (CST)
>  Received: from [64.233.162.238] (port=3333 helo=nz-out-0506.google.com)
>  by mailbag1.bizmailsrvcs.net with esmtp (Exim 4.68)
>  (envelope-from <gene.heskett+caf_=gene.heskett=verizononline.net@gmail.com>)
>  id 1J5XG9-00052G-Du    for gene.heskett@verizononline.net; Thu,
>  20 Dec 2007 20:05:09 -0600

Right here I see that google forwarded your mail from their (google) 
server sending to the bizmailsrvcs.net (verizon) server, and VZ didn't 
jump in the path, google put them there.

>  Received: by nz-out-0506.google.com with SMTP id x7so90741nzc.3 for
>  <gene.heskett@verizononline.net>; Thu, 20 Dec 2007 18:08:08 -0800 (PST)

Most likely cause is that you forwarded mail from google to verizon, 
which is probably a bad thing on many levels.

Not Verizon's fault.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
