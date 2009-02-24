Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZBXNuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZBXNuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZBXNuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:50:37 -0500
Received: from web53303.mail.re2.yahoo.com ([206.190.49.93]:32672 "HELO
	web53303.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755158AbZBXNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:50:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Q6pP8GguU6SPlpTJExecyjKvcU3Erc7gPEygUGGfkFAe36XHLlwOeiOfWsCLEM9L8GekSwEw57JIqCi1tCsuSo2elvyzv0l31NZkN5vYcEKbEfKroaaK6xGy9woBeC9mxakz9yZ3mnGiYpLBYr4Z+h54pG4efSLS28Aj3CC9ukA=;
X-YMail-OSG: nDOYMEgVM1mHR6YC9r.kowEt94TcOtN6CbvRcy4IWup5RWmSKKHLt9zf2D4SsgFX1Fn_4ygIyrD5jMFjSiSMBIQet0Kzb.QuCsJ6cvrNVJC23phC8baRAljkMqj.dw4Mtxge5XfA9gFQTK3F50wM1342odcxOgsqaXNakzPVixzJ9IKMowOnESU3l5VE8AMlLzoDk7vGlDsT6rA3Jf0-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 24 Feb 2009 05:50:34 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200902242338.14105.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <819821.83409.qm@web53303.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 2/24/09, Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > I really wish I could do more, but learning to compile
> a custom kernel for
> > my hardware and do a git bisect is something I just
> can't afford now. If
> > relevant people try to reproduce it but can't, and
> say only possible
> > solution would be for me to bisect it I guess I could
> try to give it a go
> > when I get some spare time.
> 
> Fair enough. Reporting a problem is always very
> appreciated.
> 
> Pinging Eric and Jesse ;)

Thank you Nick.

Since Arch Linux is not popular among kernel developers I just tested Fedora 10 Live-CD (KDE) and I can reproduce the exact same problem, even if Fedora 10 has kernel 2.6.27 and for me the problem appeared in .28 (but I guess Fedora adds many patches, so probably the "guilty" commit was backported to 2.6.27.5-117-FC10-i686).

Steps:
- Boot into Fedora 10 Live CD (obviously, into the default graphical mode)
- Install Powertop (yum install powertop) and run it
- I get about 60 wakeups per second from i915@pci.... leaving the system idle
- Switch to console and back to X. The wakeups are gone.

I hope that helps.


      
