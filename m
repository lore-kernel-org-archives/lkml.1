Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZFCPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZFCPpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZFCPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:45:15 -0400
Received: from drewtech.com ([66.36.241.150]:40745 "EHLO server.drewtech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbZFCPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:45:14 -0400
Message-ID: <4A269A83.3020008@drewtech.com>
Date: Wed, 03 Jun 2009 11:45:07 -0400
From: Joey Oravec <joravec@drewtech.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Rob Emanuele <poorarm@shoreis.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used
 at 	the same time
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>	 <4A1FFEFB.6050104@drewtech.com> <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com> <4A269251.8090706@atmel.com>
In-Reply-To: <4A269251.8090706@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> This systematic reset was remove by Haavard with this comment:
> "Also, don't reset the controller between each transfer. That was an
> attempt to work around earlier bugs, and it never really worked very
> well."
>   
See: 
http://lists.arm.linux.org.uk/lurker/message/20090409.120542.4f74c08d.en.html

I disagree with Haavard. Without the reset my sam9261 would exhibit DAT0 
contention, early interrupts, and other problems. Adding the reset was a 
major improvement. I emailed you some screenshots on April 10 2009 that 
demonstrate my testing. Let me know offline if either you or Havaard did 
not get the email and I can resend.

Maybe the problems are limited to this chip? We should discuss this further.

-joey

