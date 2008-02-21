Return-Path: <linux-kernel-owner+w=401wt.eu-S934871AbYBUAyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871AbYBUAyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbYBUAxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:53:51 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:28933 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762648AbYBUAxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:53:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XvjQA6xLfVVctyIBxScReKvU10IAzQwiPazHzTF3LqHovJjeO/duRjoMygdJFjjmtfS/6s83onJxOULzeh/iO8eaISJBdAsD7w4izu+RZ5gYDBtUOSX76IN+I/FlYwZO8QyXtjAPvA7Xf6jWCUnOtwCh6kCoSuksDJrwNRAib5Q=  ;
X-YMail-OSG: jEtN0XQVM1mM1wKaVayCYOL1wxzGOW73Y3e2lPEPAIq.wDzaX81iOtyUAzEuipaPEBgIC.fcCg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andre Tomt <andre@tomt.net>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Wed, 20 Feb 2008 16:53:46 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <47BAF36C.4000509@tomt.net> <200802201324.37519.david-b@pacbell.net> <47BCC4FD.1050701@tomt.net>
In-Reply-To: <47BCC4FD.1050701@tomt.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201653.47166.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2008, Andre Tomt wrote:
> David Brownell wrote:
> > On Wednesday 20 February 2008, Andre Tomt wrote:
> >> It has not crashed yet with the patch though.
> > 
> > It seems that one of the tweks in this patch made the watchdog
> > act better than before.  So unless I hear from you (before the
> > start of next week) that some other message appears, or that your
> > oops re-appears, I'll submit some version of this patch for RC3.
> 
> OOPS'ed again after some hours. The OOPS looks identical to me besides 
> all kind of other crap mixed in the trace due to a lot of unrelated 
> activity going on.
> 
> Quite a lot of the same IAA messages (status 8029 and 8028, cmd 10021) 
> in /var/log/debug prior to the crash, over the entire uptime time span.
> 
> This was with the first patch posted only. Not any of the other ones.

Hmm ... I'd have expected some other IAA/IAAD message too.


> > And if you're up for it, I may have another patch for you
> > to try on top of this one ... I had an idea about IRQ trigger
> > modes that might be causing this problem.
> 
> It'll have to be tomorrow. Should I throw in the anti-oops patch too?

Sure.  I expect you'll see the stacktrace then, instead of oopsing.

You might turn that one IAA message into an ehci_vdbg() call
instead of an ehci_dbg() call, since  the data it gives isn't
useful.  That would reduce the amount of log noise you seee.

- Dave
 

