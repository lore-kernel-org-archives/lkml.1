Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZBXMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZBXMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZBXMZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:25:14 -0500
Received: from web53309.mail.re2.yahoo.com ([206.190.49.99]:38802 "HELO
	web53309.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751852AbZBXMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:25:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Q1dGdWAKxAqbIfR2kRfOb4Q7ZpgNJ/owd/gtJgstqYSg+UMmav2Z3DdYueBUgcKVBismROmc1ioqrPGefFv/Sji3f8Gjef5mF7ONyHFE0/Jb+nr/C+B8j8Rfn1Te0HsGTo+xE4VYJqe3OyTCtWJtdIZMTB4sErsq3GyRpb2dofE=;
X-YMail-OSG: h_rZEPUVM1nccfpqmTHv968wVMiVNICuy5JOks9LfsYNHgcHCf63jJ70RudOOHR7sTRKOGAT6Mt5c29qdXNi6d0eFT4KcB4.thAR0Nl8K2zGt76sC20FcfGnFBqHOPICBTrWftjHiMmuWlleZ6zbpjifDWbW0IyYyPARoztQqG5Sy87UPFvQcCsA_sA9Buj.gj9D6h_xlvjxuPjR
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 24 Feb 2009 04:25:11 -0800 (PST)
From: Alberto Gonzalez <luis6674@yahoo.com>
Reply-To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200902242223.39069.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <77208.42754.qm@web53309.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 2/24/09, Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > Bug-Entry	:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=12337
> > > Subject		: ~100 extra wakeups reported by
> powertop
> > > Submitter	: Alberto Gonzalez
> <luis6674@yahoo.com>
> > > Date		: 2008-12-31 12:25 (55 days old)
> >
> > Still present, yes.
> 
> Any chance you could bisect it?

Well, if you look at the report you'd notice that:

- I'm using a released, stable, distro (Arch Linux, basically vanilla) kernel. I hardly know how to compile one, let alone bisect it.
- I first had the problem on my 5+ year old Pentium 4 with equally old Intel graphics (845G chipset). I thought it would be hardware specific. But now I got a new Core 2 Duo with new Intel graphics (G45 chipset), moved to 64bit, and still have the exact same problem and exact same workaround. So I really don't believe anymore it's something hardware specific and should be quite general to anyone using Intel graphics. I hoped someone with much better knowledge could reproduce it and investigate it better.

On the report, Eric Anholt mentioned a likely cause and said that Jesse Barnes had looked into a similar issue before. I cc'd him (jbarnes) on last week reminder, but got no reply.

I really wish I could do more, but learning to compile a custom kernel for my hardware and do a git bisect is something I just can't afford now. If relevant people try to reproduce it but can't, and say only possible solution would be for me to bisect it I guess I could try to give it a go when I get some spare time.

Thanks,
Alberto.


      
