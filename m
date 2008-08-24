Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYHXNFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYHXNFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 09:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYHXNFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 09:05:06 -0400
Received: from web82108.mail.mud.yahoo.com ([209.191.84.221]:23811 "HELO
	web82108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753331AbYHXNFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 09:05:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=KkD8QP1QEVWcAVEvi6XGH9lIUv5FDpXt0WLqXbqxsBYS/HB+ttYXlZuVL82tuiunpzNfxzrTuoArxcjjq8KOcjEqhU9JXix4h3Ia7SgHb4e07AHH0/XbjhWJZTiH/ZoYD2+9TBtdmJVWtZz4PPqU7zS1kBkDlHwZaI9favSDLCI=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Sun, 24 Aug 2008 06:05:04 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <751256.282.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > - Is there any chance I can get it into the stable 2.6.26.X updates?
> > (Who should I ask, or are only developers allowed to lobby for this
> > sort of thing?)
> 
> after the patch get into linus tree. Greg will put the patch into 2.6.26.X

OK, thanks a bunch.


> > - Are you worried about the potential problems of a quirk-based approach?
> > What if many more people experience a similar regression once 2.6.26 or
> > later appears in their distribution?  I'm sure you don't want to have to
> > write a different quirk for each individual's hardware, and this problem
> > did not arise with the approach used for resource management in 2.6.25.
> 
> this patch should be safe.
> 
> 2.6.26 is fixing one bug about reserving local apic address and that
> in e820 table.
> and it reveals one bios bug.

Correction -- it revealed at least two.  See the link I posted earlier in
this thread:

http://www.uwsg.indiana.edu/hypermail/linux/kernel/0808.2/1807.html

Scroll down to the line that starts with "[blog]" for the link. You can see
the discussion I had encouraging him to come here to help us troubleshoot 
if you go to that blog and click "Comments".

I only mention this as a warning, in case it could lead to a lot of extra 
problems for you later.  If you're quite sure that everything is OK, then 
all I can do is thank you again and keep my fingers crossed for you and the
kernel team that nothing bad happens when 2.6.2[67] hit the major distros.

Thanks Yinghai and Ingo (and Peter, Paul, Bill, Mike, Ilpo, Frans, Jesse...
and Andrew, for being the only one to tell me my ISP webmail client was 
breaking threading in everyone's inbox!)


Now leaving LKML...
Dave Witbrodt
