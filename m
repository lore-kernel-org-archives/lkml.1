Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXEZQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXEZQIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXEZQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:08:26 -0400
Received: from www.osadl.org ([213.239.205.134]:58554 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752772AbXEZQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:08:25 -0400
Subject: Re: 2.6.21-rt2..8 troubles
From: Thomas Gleixner <tglx@linutronix.de>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <46574DE4.2080900@rncbc.org>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
	 <46574DE4.2080900@rncbc.org>
Content-Type: text/plain
Date: Sat, 26 May 2007 18:08:29 +0200
Message-Id: <1180195709.4264.7.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 21:58 +0100, Rui Nuno Capela wrote:
> Is there anything I can do better to help myself figuring out this
> issue? As this is a  modern laptop such things like a serial console are
> unavailable, but it would be nice to track things up over netconsole
> perhaps?
> 
> I just need some bright and nice directions now ;) Hope someone finds
> this worth of attention too. Meanwhile, I'll be happy with 2.6.21-rt1 :)

Can you boot with "hpet=disable" on the command line ?

If that does not help, please provide the output of /proc/timer_list.

Thanks,

	tglx


