Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbXFYTfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbXFYTfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXFYTfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:35:33 -0400
Received: from nn7.de ([85.214.94.156]:36172 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbXFYTfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:35:33 -0400
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path -
	microcode	update fix
From: Soeren Sonnenburg <kernel@nn7.de>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <46800759.6040605@assembler.cz>
References: <1182026585.4230.8.camel@localhost>
	 <20070616231745.1b0f7bd9@hyperion.delvare>
	 <1182071803.4815.5.camel@localhost>  <467575BF.1090207@assembler.cz>
	 <1182335403.21563.99.camel@localhost>  <467AE640.9090409@assembler.cz>
	 <1182779850.21781.11.camel@localhost>  <46800759.6040605@assembler.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Jun 2007 21:35:28 +0200
Message-Id: <1182800128.4674.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 20:20 +0200, Rudolf Marek wrote:
> > Hi Rudolf,
> > 
> > just one more update:
> > 
> > When I put my machine into s2ram and make it resume, one of the coretemp
> > sensors gets lost. Ahh and I am already rmmod coretemp / loading
> > microcode after resume / insmod coretemp...
> 
> Hello, If I understand correctly you unload the driver before suspend. Resume, 
> update microcode, load the driver correct?

no I did not unload the driver but rmmod it after resume before I load
the microcode.

> Please can you check dmesg if for example one core complains about bad microcode 
> version?

indeed core1 still complains. and I just now loaded the new microcode
( rmmod of coretemp before and insmod after) and voila coretemp displays
both cpu's again. So I guess the microcode reloading is done to soon
after resume...

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
