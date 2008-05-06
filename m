Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbYEFDXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbYEFDXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYEFDXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:23:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:40107 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYEFDXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:23:40 -0400
Subject: Re: x86: Clean up computation of HPET .mult variables
From: Daniel Walker <dwalker@mvista.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20080506021321.GA4928@Pilar.virtua.com.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
	 <1210031888.17132.85.camel@localhost.localdomain>
	 <20080506021321.GA4928@Pilar.virtua.com.br>
Content-Type: text/plain
Date: Mon, 05 May 2008 20:23:38 -0700
Message-Id: <1210044218.17132.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 23:13 -0300, Carlos R. Mafra wrote:
> So the savings in my patch is due to using the period directly, and
> not the frequency. That's what my idea was, so if you object then
> my attempt was a failure and should be forgotten :-)
> 
> Or maybe I should create a clocksource_period2mult to replace 
> clocksource_hz2mult and save the extra operation in more places too?

The one concern I have is the rounding that is done in the
clocksource_hz2mult(). The div_sc doesn't include it .. You could add a
clocksource_period2mult(), that would help out any one later that has a
period instead of hz ..

Daniel

