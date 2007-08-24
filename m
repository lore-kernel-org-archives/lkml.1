Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXHXN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXHXN2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760566AbXHXN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:28:05 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:46922 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbXHXN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:28:05 -0400
Date: Fri, 24 Aug 2007 15:27:45 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Bob Picco" <bob.picco@hp.com>
Cc: john stultz <johnstul@us.ibm.com>, "Luck, Tony" <tony.luck@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
Subject: Re: "double" hpet clocksource && hard freeze [bisected]
Message-ID: <20070824152745.56214a24@localhost>
In-Reply-To: <20070824124631.GF10594@localhost>
References: <20070823222115.122a37ca@localhost>
	<617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	<1187903135.6024.18.camel@localhost.localdomain>
	<1187905306.6024.24.camel@localhost.localdomain>
	<20070824124631.GF10594@localhost>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 08:46:31 -0400
"Bob Picco" <bob.picco@hp.com> wrote:

> Prevent duplicate names being registered with clocksource. This also
> eliminates the duplication of hpet clock registration when the arch
> uses the hpet timer and the hpet driver does too. The patch was
> compile and link tested.

This one works too.

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g1a8f4610-dirty on x86_64
