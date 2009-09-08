Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679AbZIHQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbZIHQk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZIHQkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:40:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZIHQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:40:24 -0400
Subject: Re: Stop using tasklets for bottom halves
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com
In-Reply-To: <20090908091143.1e613963@nehalam>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com>
	 <20090907171406.6a4b6116@nehalam>
	 <1252376254.21261.2052.camel@gandalf.stny.rr.com>
	 <20090908091143.1e613963@nehalam>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 12:40:23 -0400
Message-Id: <1252428023.15626.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 09:11 -0700, Stephen Hemminger wrote:

> > > Process context is too slow.
> > 
> > Well, I'm hoping to prove the opposite. I'm working on some stuff that I
> > plan to present at Linux Plumbers. I've been too distracted by other
> > things, but hopefully I'll have some good numbers to present by then.
> > 
> 
> 
> That's great, does it keep the good properties of NAPI (irq disabling
> and throttling?)

Not exactly sure what you mean by throttling, but I'm assuming it will.

As for irqs disabling, I'm trying to avoid doing that. Note, the device
will have its interrupts disabled, but not all other devices will.

-- Steve


