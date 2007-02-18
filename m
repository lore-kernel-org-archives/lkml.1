Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXBRMSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXBRMSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXBRMSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:18:15 -0500
Received: from web36713.mail.mud.yahoo.com ([209.191.85.47]:32086 "HELO
	web36713.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750782AbXBRMSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:18:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=1ftBRaUIF0xpgy31PA5/b11hsAqS/faCKlAsnxsC2w6cp0uAMJXG0VrbS5UFUgTACneneZgDqlMXl81es6qRKQcuvvEgZhhWBLE/YOgLXALf7TtrPPxLDpaWq6QQCYsGGYPdGIAlyeCiAsdNISJ2J8seazfhLZJ+MwIufj2scxM=;
X-YMail-OSG: TMipz2YVM1nH8TunEVADPZZAc_0UuXYtBAF1whV8pOYQWgOxzIi3Fm6oc3tkJw6PGeaPUwuiDE1ipSpT1_ma1VH_ZC5uTtW5RDMi7BIOZNxXmzzNWUSw9Pmezs9a382FFV4xIZ3Djj3_lz8-
Date: Sun, 18 Feb 2007 04:18:13 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] incorrect behavior on resume
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
In-Reply-To: <20070218065318.GA14251@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <659829.32221.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't see that - as I say above, the correct sequence is:
> 
>  - host device resume
>      - calls mmc_resume_host()
>  - child's device resume (mmc_blk_resume)
>      - mmc_queue_resume()
> 
Of course, I understand that this is a correct sequence. It simply was not obvious to me that host
will issue requests even if mmc_resume_host is not called.

I'm trying to implement a hotplugable host, so I assumed that if host was removed during the
suspended state there's no need to resume it.



 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
