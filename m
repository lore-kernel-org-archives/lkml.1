Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYDGJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYDGJWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYDGJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:22:06 -0400
Received: from web26202.mail.ukl.yahoo.com ([217.12.10.239]:44744 "HELO
	web26202.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752976AbYDGJWF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:22:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=0uTgpNd2q85yzwUdQM4IWlDJS7KrlmHygEq3fzoXZl0fBJjb6ORVhzh94/WvfUIHiirLodjJujzaUiRiQ11Faycvkdhuh6LOwxI8GsQ/cVVp5k+GmoBvSIHhq7kckIDmNip9Dc7D9iq4AAeaUk4mP8IMKG/EjIbrrFWvtadvb8U=;
X-YMail-OSG: gBgZZHMVM1keloDAjRaQ95Qu.4D0_hPQKfGj7oQtjG93s.6cQK.3krNbDLTp5zRqK6Al6uNgxTpLgTZ4RpY_jQP1HK0ijFtbHlHzEUOrySHYCgxi6wUsydCJg4Y-
X-Mailer: YahooMailWebService/0.7.185
Date: Mon, 7 Apr 2008 09:22:03 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style patch
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <649693.333.qm@web26202.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > the interrupt handler will be triggered as soon as we
> > enable the TX
> > interrupt. But perhaps we should avoid enabling the
> > interrupt and
> > schedule the tasklet since we _know_ there's a TX
> > interrupt pending?
> > 
> Ok, you are right, schedule the tasklet is better. I do
> some
> test and post another patch. 
> 
Just a comment. I can't schedule the tasklet for the tasklet itself
so maybe waiting for interrupt is a more clean solution.
What do you think?
> Michael
> 
> 
>       Inviato da Yahoo! Mail. 
> La casella di posta intelligente.
> http://it.docs.yahoo.com/mail/overview/index.html


      Inviato da Yahoo! Mail. 
La casella di posta intelligente.
http://it.docs.yahoo.com/mail/overview/index.html
