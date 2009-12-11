Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZLKKWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZLKKWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbZLKKV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:21:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54870 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754802AbZLKKV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:21:56 -0500
Date: Fri, 11 Dec 2009 10:21:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Questions about Watch Dog Timer under Linux.
Message-ID: <20091211102159.GB18825@rakim.wolfsonmicro.main>
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
 <20091209145919.GH9018@sirena.org.uk>
 <f9f38a550912110027r70710867k3a08c6d5913ce13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9f38a550912110027r70710867k3a08c6d5913ce13@mail.gmail.com>
X-Cookie: Do not exceed recommended dosage.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 04:27:55PM +0800, Cypher Wu wrote:

Please reply in-line to e-mails, it makes the conversation much easier
to follow.

> It seems WATCHDOG_NOWAYOUT is a software mechanism? If it is defined
> as 1 then the WDT can't be stopped if it has been started whether bye
> closing the device file or writing the magic character 'V'.

Yes, it's a kernel build time configurable option to select this
behaviour.  In effect all you'd be doing is making a driver which turns
it on all the time.
