Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYDBHsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYDBHsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYDBHsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:48:13 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:21361 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754294AbYDBHsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:48:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=p8GwPFzzUfjWobSF+TP7IXCVXoQCgRXT1yBdIH5NtjFaES22rn4vW2K6lIFLD6vM03B1XcFM0MsEUGHowdgwco0vWHcT33K2EuUd4sN4mx0f3hpgE4YZPple4AQN0zegAt8JYqXd3ywmjXPQjlxuJgnDp1PlabH0cURxTlSyOGQ=  ;
X-YMail-OSG: GkFVyGcVM1nO7dNHaoBNYKSQv_rBaZu387T371lL7a0jY0uBpXQHUPS836Tzkn.5VSzHvghRUQ--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 02 Apr 2008 00:48:50 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org, davem@davemloft.net,
       akpm@linux-foundation.org
Subject: Re: + sparc32-delete-bogus-js-rtc-records.patch added to -mm tree
Cc: mm-commits@vger.kernel.org
References: <200803312351.m2VNpc2p032266@imap1.linux-foundation.org>
 <20080402.001432.159603826.davem@davemloft.net>
In-Reply-To: <20080402.001432.159603826.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080402074850.DA9862BF24C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Subject: sparc32: delete bogus js-rtc records
> > From: David Brownell <david-b@pacbell.net>
> > 
> > While looking at the legacy RTC drivers in the drivers/char directory, I
> > noticed what looks like bogus entry for SPARC32 systems: JS_RTC, which seems
> > to rely on a non-existent js-rtc file.  Just delete it.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> It is actually used.  ...

Right, as came up on a different email thread.

It's pretty a pretty bogus hack, but unless the other "rtc"
module changes its name to something more reasonable, this
particular legacy RTC code needs to linger.

- Dave

>
> Andrew, please drop this one.
>
> Thanks.
>
