Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXDFW5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXDFW5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDFW5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:57:16 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:24448 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933274AbXDFW5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:57:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4ksGRfaMVpfjG9gtNu6WjLS5mRVOHGjxDdpFywLrlD53AuyKsBfwTjvbPQK7sqlQgozsZ19xj8XuGiXrxsayANmOJuOXL/J9azdljmSZ4ymKmjtsq4Iy27nlpbpi6hWq4gfHC9dbpsHjV66Hdyce3cGJhxbWpmTmPkwsXwCcUCU=  ;
X-YMail-OSG: VdxkQZ8VM1nKWScY1WCdmjecntlX19En6S1gdTVXSEfmn8EabEHmKNQAsuIQQBPX_3U4YPzKHe_P51mszWkS056NLePL61QFQhl26cuqvqYoYX6IYiU-
From: David Brownell <david-b@pacbell.net>
To: tglx@linutronix.de
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
Date: Fri, 6 Apr 2007 15:57:12 -0700
User-Agent: KMail/1.7.1
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061405.50169.david-b@pacbell.net> <1175897876.28263.490.camel@localhost.localdomain>
In-Reply-To: <1175897876.28263.490.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061557.12662.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 3:17 pm, Thomas Gleixner wrote:
> David,
> 
> http://tglx.de/private/tglx/usbnet.png
> 
> /me recommends emacs-develock.el for colorful white space wreckage
> display !

Then I'd have to switch to EMACS ... no thanks!  ;)

At the risk of switching to a VI/EMACS flamewar (could that be
an improvement?) "let c_space_errors=1" shows the same sort of
thing ... albeit a bit more usefully, it just highlights the
single useless space character at the beginning of that line.
(Which starts "space-TAB-TAB-TAB".)


> You probably want to look at more files contributed by david-b before
> you look at mine :)

I last touched that header in 2005 ... next time I have reason to
touch it, I'll likely fix that little thing!   Patches accepted.  :)


This particular issue doesn't actually affect indentation, since the
tab trumps that space.  So it's a bit off-agenda for this particular
flamage.  I tend to fix such space errors whenever I trip over them;
e.g. "git show 438d6c2c015cf63bf7e9bdc2033d435433ac8455".

- Dave
