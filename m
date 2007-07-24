Return-Path: <linux-kernel-owner+w=401wt.eu-S935999AbXGXMAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935999AbXGXMAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXGXL76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:59:58 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3762 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754098AbXGXL75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:59:57 -0400
Date: Tue, 24 Jul 2007 14:00:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?ISO-8859-1?B?SGFucy1K/HJnZW4=?= Koch <hjk@linutronix.de>
Cc: Adrian Bunk <bunk@stusta.de>, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] drivers/hwmon/lm93.c: array overruns
Message-ID: <20070724140000.73840fcf@hyperion.delvare>
In-Reply-To: <200707241026.46814.hjk@linutronix.de>
References: <20070723005453.GS26212@stusta.de>
	<200707230936.58135.hjk@linutronix.de>
	<20070724101020.0f1bf458@hyperion.delvare>
	<200707241026.46814.hjk@linutronix.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, 24 Jul 2007 10:26:46 +0200, Hans-Jürgen Koch wrote:
> Am Dienstag 24 Juli 2007 10:10 schrieb Jean Delvare:
> > However, I see that temp4 (which isn't a real temperature channel) is
> > not exposed in sysfs. Reading and storing register values you never use
> > doesn't seem particularly interesting, so something needs to be done
> > here: either drop support for temp4 entirely, or expose the temp4
> > values in sysfs.
> 
> I've got that on my TODO list. I'll soon work on that driver again. I'm still
> waiting for that #§$?& NDA-covered datasheet of the LM94. As soon as I've got
> that, I need to review all these values anyway because there might be subtle
> differences between LM93 and LM94.
> For the moment, I'd like to postpone the decision about what to do with temp4.

Sure, no problem.

-- 
Jean Delvare
