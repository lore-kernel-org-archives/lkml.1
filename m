Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXDHUHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXDHUHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXDHUHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:07:30 -0400
Received: from homer.mvista.com ([63.81.120.158]:38049 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXDHUHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:07:24 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, mingo@elte.hu
In-Reply-To: <1176021199.28263.529.camel@localhost.localdomain>
References: <20070405210316.785839431@mvista.com>
	 <20070407031922.ee49478f.akpm@linux-foundation.org>
	 <1175967839.15973.156.camel@imap.mvista.com>
	 <1175979019.28263.523.camel@localhost.localdomain>
	 <1175981431.15973.158.camel@imap.mvista.com>
	 <1176021199.28263.529.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 13:02:42 -0700
Message-Id: <1176062563.15973.163.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 10:33 +0200, Thomas Gleixner wrote:
> 
> Oh well, this is a leftover from the days where we tried to use TSC
> despite of frequency changes. It still modifies the scale factor of the
> tsc clocksource. 
> 
> I agree that it can be removed as we switch off TSC anyway in that case.

That's what I was thinking .. However, I wanted to wait for John to
comment on it also ..

Dainel

