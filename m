Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbZKLREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbZKLREw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZKLREv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:04:51 -0500
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:46174 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753667AbZKLREs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:04:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 750150.69587.bm@omp107.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=EgOMNJzEREJoq2Xs+J0Fwe1micuqmUPZ4f5hFBwh2az99nFdX6C0JSLMjdNVuJb78dyqzKPjLtGB7p61PLkoVciGBkAy0Cpl6EjTYlrVco48Zwdm17gXY598vjjNvuRn2tRI05kluyEz/zf8wapnb8OcS0AWkvpWlR9j7crEWpk=;
Message-ID: <661913.35266.qm@web113707.mail.gq1.yahoo.com>
X-YMail-OSG: JAdayoUVM1n7b39oW3FKB8o8riIFxeTLkXM2ZgmI5EhxSnT_BYy56H48CjN7RtDSGNxpwE6IN_rTHP9tvrH6RBGtHLej4zukAk40bzonAQ85IVU1KK12E6kzbjaFVOY_znYWdGHGADt2UDLnRrYxIAcOEG4HQ_fyNPNA9FPlXr7b10XyUEJgZXWf_ClLRe4nZfx9Q8xwyoEOh6yThNVIeHWIyBANIBYd63RsDnpBARWX.dIG1quVFhJ4G2_N2NqokCiCrjQz_EUHOlzlOb0QtzNJdDUlb63WkUZX4_71cvkZUJU1OWwz0x45HOY-
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.7.347.3
Date: Thu, 12 Nov 2009 09:04:53 -0800 (PST)
From: Andres Baldrich <andresbaldrich@ymail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <alpine.LFD.2.01.0911120714260.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



El jue 12-nov-09, Linus Torvalds <torvalds@linux-foundation.org> escribió:
> On Thu, 12 Nov 2009, Tejun Heo wrote:
> > 
> > 11/12/2009 07:36 PM, Ingo Molnar wrote:
> > > 
> > > Breaking strings mid-sentence is something we try
> not to do. (If you 
> > > know about places that do it 'quite often' then
> those places need fixing 
> > > too.)
> > 
> > Oh... I do that all the time and I see a lot of them
> around too.
> 
> I hate them. I do greps for error messages, and it's
> annoying as hell if 
> it's hard to find.
> 
> 'checkpatch' is the major reason for them, but I think
> we've fixed 
> checkpath long ago to not warn about long lines if they are
> due to a long 
> string.
> 
> Strings should basically be broken up only at '\n'
> characters, so
> 
>     printk("This is a made-up example.\n"
>         "Ok like this\n");
> 
> is fine, because you can expect to grep for "made-up
> example", but not 
> over the newline.
> 
>            
>     Linus


(Kernel)/Documentation/CodingStyle
line 83:
"Statements longer than 80 columns will be broken into sensible chunks.
Descendants are always substantially shorter than the parent and are placed
substantially to the right. The same applies to function headers with a long
argument list. Long strings are as well broken into shorter strings. The
only exception to this is where exceeding 80 columns significantly increases
readability and does not hide information.

void fun(int a, int b, int c)
{
	if (condition)
		printk(KERN_WARNING "Warning this is a long printk with "
						"3 parameters a: %u b: %u "
						"c: %u \n", a, b, c);
	else
		next_statement;
}"

Perhaps it should be changed?
I read the list's faq, it asked useful code or "diff" outputs for proposed changes, but i am an *absolute* beginner with < 6 months of college. 'Never' used FOSS before.
I hope it was good imput.
Andrés Baldrich   <abaldric@alu.itba.edu.ar>


      Yahoo! Cocina

Encontra las mejores recetas con Yahoo! Cocina.


http://ar.mujer.yahoo.com/cocina/

