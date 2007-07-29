Return-Path: <linux-kernel-owner+w=401wt.eu-S936334AbXG2WPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936334AbXG2WPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937378AbXG2WOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:14:47 -0400
Received: from web52001.mail.re2.yahoo.com ([206.190.49.248]:42765 "HELO
	web52001.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936572AbXG2WOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:14:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Ohiecprg9qrC3g8byGryBp6Jklgtq0rUFK4JxZjWXedRtDpV7kDWDieaJ2CDaOZAbjw4L9G/nO+Ko0+A34TuWF8R2Mj0YFnM6tjK87vdrAtJ/qCJ2sRzMApxLjWl/MJoeiETHtM8kBZ3wdoRWvAa3JuzKf139QRiMPzWqsy5/y8=;
X-YMail-OSG: yTK7zvAVM1nmYEiehmBYxBbgWf28MNMnISfbW8s4WBzjieSjY82g6nIfEZiQaF3OCg--
Date: Sun, 29 Jul 2007 15:14:31 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Re: Reading a bad sector does not report failure as 'read error' but hangs PC with 'Machine Check Exception'
To: linux-kernel@vger.kernel.org
In-Reply-To: <20070729213051.20ebc51e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <243184.6177.qm@web52001.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I did actually not copy the coreret code in the
mcelog, leaving me some errors about the Northbridge.
If I do it again it gives me something else. I made 2
digital photo's of 2 lockups when it happened and this
is the result of the tool, the TSC is different in
both errors, the rest is the same:

--------------------
CPU 0 4 northbridge TSC b7d4a144d0 
  Northbridge Watchdog error
       bit57 = processor context corrupt
       bit61 = error uncorrected
  bus error 'generic participation, request timed out
      generic error mem transaction
      generic access, level generic'
STATUS b200000000070f0f MCGSTATUS 4
This is not a software problem!
--------------------
CPU 0 4 northbridge TSC c4dd3a549f 
  Northbridge Watchdog error
       bit57 = processor context corrupt
       bit61 = error uncorrected
  bus error 'generic participation, request timed out
      generic error mem transaction
      generic access, level generic'
STATUS b200000000070f0f MCGSTATUS 4
This is not a software problem!
--------------------

It's a bit strange but if I copy the results from my
first post I get the Northbridge error, perhaps
because there is an 'enter' between the first line
with the 'bank 4' and the 'b200000000070f0f' line. The
mcelog tool handles this different from the error in 1
line. 

Regards,
Hendrik


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
