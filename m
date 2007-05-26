Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXEZQMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXEZQMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXEZQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:12:05 -0400
Received: from www.osadl.org ([213.239.205.134]:34673 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753366AbXEZQMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:12:03 -0400
Subject: Re: [2.6.21.1] soft lockup when removing netconsole module
From: Thomas Gleixner <tglx@linutronix.de>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
In-Reply-To: <465857DF.2020603@gmail.com>
References: <20070526154011.GB3735@vanheusden.com>
	 <465857DF.2020603@gmail.com>
Content-Type: text/plain
Date: Sat, 26 May 2007 18:12:07 +0200
Message-Id: <1180195927.4264.11.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 11:53 -0400, Parag Warudkar wrote:
> Seems to be hrtimers related - CC'ed Thomas.

I doubt that. The tick interrupt just finds out, that the machine is
stuck in rmmod.

> > Also the rmmod hangs and would not exit even with kill -9. It also
> > sucks up 100% cpu.

Can you please enable CONFIG_PROVE_LOCKING ?

Thanks,

	tglx


