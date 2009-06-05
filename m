Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZFEOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZFEOk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZFEOkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:40:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42164 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZFEOkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=EDp7XJb10b13YcV7PyGbHbG35Ue5kRAzwa2aqVWA7JWN12Kfcm0sb5n8ws+Vl13Y20
         b7XW2AH+4LqGYH/f/hLLXz/FdKtII2Z9kZZcUWLuSj0JroMrh4TjuAATwP53q+lXj9NP
         36SK8LdnFZe3PnQRS3KIEiLaX5Urbs18mbA6w=
To: Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-i2c@vger.kernel.org
Subject: Re: [PATCH 3/9] I2C: i2c-ocores: Can add I2C devices to the bus
References: <4A292050.7010602@mocean-labs.com>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Fri, 05 Jun 2009 16:40:15 +0200
In-Reply-To: <4A292050.7010602@mocean-labs.com> ("Richard =?utf-8?Q?R?=
 =?utf-8?Q?=C3=B6jfors=22's?= message of "Fri\, 05 Jun 2009 15\:40\:32
 +0200")
Message-ID: <87k53qyca8.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Richard" == Richard Röjfors <richard.rojfors.ext@mocean-labs.com> writes:

 Richard> There is sometimes a need for the ocores driver to add
 Richard> devices to the bus when installed.

 Richard> i2c_register_board_info can not always be used, because the
 Richard> I2C devices are not known at an early state, they could for
 Richard> instance be connected on a I2C bus on a PCI device which has
 Richard> the Open Cores IP.

 Richard> i2c_new_device can not be used in all cases either since the
 Richard> resulting bus nummer might be unknown.

 Richard> The solution is the pass a list of I2C devices in the
 Richard> platform data to the Open Cores driver. This is useful for
 Richard> MFD drivers.

 Richard> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
