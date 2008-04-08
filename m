Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYDHIoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYDHIoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYDHIoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:44:07 -0400
Received: from web26208.mail.ukl.yahoo.com ([217.12.10.245]:47106 "HELO
	web26208.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753049AbYDHIoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:44:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=iW5i1Bg5MLNOuWXLYhtwk96O6fMec+fx3GjDQZndExPUl31QAe2LZS+mKHwVJQq5Namgryk2eKELiKywIxRTun+BTQvRt9RbjVV4wkShDzEUYAE9LLdvnAS0rXNzWp/PgjcYG9KXEwu8PZ3swmu/CcudgLiNlLx7OJ2YczIrmsk=;
X-YMail-OSG: 3dsX1fcVM1lHQFKR_Zx7GCzsAIjJJoXrYoaAsFbZlH4_rc0x6Pq42yg2TrUalqsG_A--
X-Mailer: YahooMailWebService/0.7.185
Date: Tue, 8 Apr 2008 08:44:01 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: Re: [PATCH] atmel serial reduce trasmitting window & code style patch
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
In-Reply-To: <200804081032.32883.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <156492.41050.qm@web26208.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> For me this loop will never run more than 2-3 times.
> The CPU is much faster than the serial transmitter, so
> after 2 loops
> UART_GET_CSR(port) & ATMEL_US_TXRDY will be false and
> the loop will exit.
> 
Ok, I do a check, and count the max.

Michael



      Inviato da Yahoo! Mail. 
La casella di posta intelligente.
http://it.docs.yahoo.com/mail/overview/index.html
