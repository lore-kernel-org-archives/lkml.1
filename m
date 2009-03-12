Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZCLOG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZCLOG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZCLOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:06:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:16240 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZCLOGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:06:16 -0400
Date: Thu, 12 Mar 2009 15:06:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: feature-removal-schedule.txt for some I2C functions
Message-ID: <20090312150603.1aecdba9@hyperion.delvare>
In-Reply-To: <20090312102617.3235a35b@pedra.chehab.org>
References: <20090312102617.3235a35b@pedra.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, 12 Mar 2009 10:26:17 -0300, Mauro Carvalho Chehab wrote:
> Hi Jean,
> 
> On your entry at Documentation/feature-removal-schedule.txt:
> 
> What:   i2c_attach_client(), i2c_detach_client(), i2c_driver->detach_client()
> When:   2.6.29 (ideally) or 2.6.30 (more likely)
> Why:    Deprecated by the new (standard) device driver binding model. Use
>         i2c_driver->probe() and ->remove() instead.
> Who:    Jean Delvare <khali@linux-fr.org>
> 
> You forgot to add a check entry, like:
> Check: i2c_attach_client i2c_detach_client i2c_driver->detach_client
> 
> The check entry is used by checkpatch.pl to warn about the usage of a legacy function.
> 
> Please fix it, since me and others rely on this tool to discover about the
> usage of legacy functions.

Thanks for the tip, I didn't know about this. Is there some
documentation about the Check: entry format? If checkpatch.pl simply
matches the strings then i2c_driver->detach_client is never going to
match, so there's no point in adding it.

-- 
Jean Delvare
