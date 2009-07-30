Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZG3SIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZG3SIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 14:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZG3SIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 14:08:35 -0400
Received: from fifo99.com ([67.223.236.141]:52027 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZG3SIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 14:08:35 -0400
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
From: Daniel Walker <dwalker@fifo99.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248974187.3331.6.camel@work-vm>
References: <200907291717.n6THHG6f001426@d06av06.portsmouth.uk.ibm.com>
	 <20090730125351.6f16e9ec@skybase> <1248958173.6046.32.camel@desktop>
	 <20090730150456.6c87b997@skybase>  <1248961750.6046.35.camel@desktop>
	 <1248974187.3331.6.camel@work-vm>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 11:08:40 -0700
Message-Id: <1248977320.6046.66.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 10:16 -0700, john stultz wrote:
> Clocksources as modules was one of the initial design goals I had way
> back. The benefit being that an older distro kernel could be made to
> support newer stranger hardware via a clocksource driver. While the
> hardware vendors have for the most part consolidated on HPET/ACPI PM
> which has mostly avoided the need, I still think its worth preserving.

If the PIT case is a real use case for unregister than we can keep it
around. If not, then that path just becomes unused and all unused code
is open for removal from my perspective.

If the case you describe above is a good one, then someone eventually
will add back the unregister path. Which should come with a good reason
and with an actual user of the code..

Daniel

