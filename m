Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXFYSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXFYSUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 14:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXFYSU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 14:20:26 -0400
Received: from ms.trustica.cz ([82.208.32.68]:53312 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbXFYSUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 14:20:25 -0400
Message-ID: <46800759.6040605@assembler.cz>
Date: Mon, 25 Jun 2007 20:20:09 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: Soeren Sonnenburg <kernel@nn7.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path - microcode	update
 fix
References: <1182026585.4230.8.camel@localhost>	 <20070616231745.1b0f7bd9@hyperion.delvare>	 <1182071803.4815.5.camel@localhost>  <467575BF.1090207@assembler.cz>	 <1182335403.21563.99.camel@localhost>  <467AE640.9090409@assembler.cz> <1182779850.21781.11.camel@localhost>
In-Reply-To: <1182779850.21781.11.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Rudolf,
> 
> just one more update:
> 
> When I put my machine into s2ram and make it resume, one of the coretemp
> sensors gets lost. Ahh and I am already rmmod coretemp / loading
> microcode after resume / insmod coretemp...

Hello, If I understand correctly you unload the driver before suspend. Resume, 
update microcode, load the driver correct?

Please can you check dmesg if for example one core complains about bad microcode 
version?

Thanks,
Rudolf
