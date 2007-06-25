Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbXFYN5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbXFYN5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXFYN5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:57:34 -0400
Received: from nn7.de ([85.214.94.156]:59796 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbXFYN5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:57:34 -0400
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path - microcode
	update fix
From: Soeren Sonnenburg <kernel@nn7.de>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <467AE640.9090409@assembler.cz>
References: <1182026585.4230.8.camel@localhost>
	 <20070616231745.1b0f7bd9@hyperion.delvare>
	 <1182071803.4815.5.camel@localhost>  <467575BF.1090207@assembler.cz>
	 <1182335403.21563.99.camel@localhost>  <467AE640.9090409@assembler.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Jun 2007 13:57:30 +0000
Message-Id: <1182779850.21781.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 22:57 +0200, Rudolf Marek wrote:
> Hello Soeren,
[...]
> Soeren pointed at some T60, T60p BIOS update and luckily, there is a
> easy way 
> how to extract the microcode update and even convert it into the .txt
> format as 
> microcode update utility (http://www.urbanmyth.org/microcode/)
> expects.
> Attached scripts generates the mcode.txt file which may be used by the
> update 
> utility. Please can you give a try?

Hi Rudolf,

just one more update:

When I put my machine into s2ram and make it resume, one of the coretemp
sensors gets lost. Ahh and I am already rmmod coretemp / loading
microcode after resume / insmod coretemp...

Any idea's on that ?

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
