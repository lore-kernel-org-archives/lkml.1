Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYEGEVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYEGEVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYEGEVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:21:37 -0400
Received: from homer.mvista.com ([63.81.120.158]:10085 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYEGEVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:21:36 -0400
Subject: Re: x86: Clean up computation of HPET .mult variables
From: Daniel Walker <dwalker@mvista.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
In-Reply-To: <20080507033931.GA5378@Pilar.virtua.com.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br>
	 <1210031888.17132.85.camel@localhost.localdomain>
	 <20080506021321.GA4928@Pilar.virtua.com.br>
	 <1210044218.17132.109.camel@localhost.localdomain>
	 <20080506125920.GA26295@beyonder.ift.unesp.br>
	 <1210090880.17132.140.camel@localhost.localdomain>
	 <20080506205003.GA3749@beyonder.ift.unesp.br>
	 <1210126661.17132.223.camel@localhost.localdomain>
	 <20080507033931.GA5378@Pilar.virtua.com.br>
Content-Type: text/plain
Date: Tue, 06 May 2008 21:21:34 -0700
Message-Id: <1210134094.17132.228.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 00:39 -0300, Carlos R. Mafra wrote:
> So comparing with the numbers you quoted from your experiments
> you will realize that the value you got with my patch is actually
> 10 times better, so your assumption about clocksource_hz2mult
> being more correct is not good.

If that's the case then we really need to correct
clocksource_hz2mult() .. Since that function is what we use to calculate
the mult in most cases.

Daniel

