Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXDIPWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXDIPWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXDIPWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:22:11 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:29690 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753459AbXDIPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:22:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=i4pxYAyzFReSm6FEwvAzihxIyHEEgCXSAQAdT8fGtfDEScEXEmxSnuR4Qa68Mxux7acpwWo0m6o+01DhrGztgSeihqkObUPnxxWlx87THpUbsd32dyuE8+cKKjJIA81M/LK8yO8Qde57Uzqb4131nRpDvqI96gnqPqFRWIu5qDw=  ;
X-YMail-OSG: iU5tGWYVM1nrrDnWRuzBZKtSXqrqbJ8HSBvKfDjUSGZ1vTGS8yKx0F59ZJgpp88IgXx7TqqiKQ--
From: David Brownell <david-b@pacbell.net>
To: Junio C Hamano <junkio@cox.net>
Subject: Re: coding style for long conditions
Date: Mon, 9 Apr 2007 08:14:17 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061634.39344.david-b@pacbell.net> <7v8xd4fwap.fsf@assigned-by-dhcp.cox.net>
In-Reply-To: <7v8xd4fwap.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704090814.18137.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > So in practical terms "\n \t" and "\n\t" are identical;
> > although the former "should not" be used, it doesn't
> > actually affect what CodingStyle is primarily trying to
> > control (i.e. what the code looks like).
> 
> That's not what CodingStyle is trying to control.  Not "what the
> code looks like" at all.

That's news to many folk.  "What the code looks like" has always
been the fundamental reason to have coding conventions.  If you
look at coding convention documents over the last fifty years or
so you will notice that's what they're about ... even back in the
days when "text" came on punched cards or line printer output.


The "extraneous hidden whitespace" stuff is sort of a new issue.
I happened across a discussion of it on the GCC list last month ...
it's a meme that wasn't widespread even five years ago.

That "get a decent editor" thing is because some editors are so deeply
broken that they think it's actually OK to replace tabs with whitespace,
or automatically add extraneous whitespace.  Also, because some emailer
tools do the same thing.  (Yet another reason to dislike Microsoft, sigh.)

Secondarily, it's also because having "hidden" spaces can cause hassles
when maintaining code.

Me, i've always been offended by all the wasted disk space, but I think
I'm a minority there.  ;)

- Dave
