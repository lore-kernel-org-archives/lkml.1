Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZFGIv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZFGIv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZFGIvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:51:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:42925 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZFGIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X3HNnMVIgqwV8jRB8dNHXuUatNwLx0qTNk4wIdZlVsCLnbYDS9eCLK0+JJ1wvt9ZqX
         I2xQRMOdfQHQjZ3kxOH0K0LQNGKm+pWaG4bkbkFjSuzlz+Vb0WqRz3nzfNocTzIzVuxL
         p8Bs0LrFmX60jHxRGLKlXEYJWfcjoty8nTe5E=
Message-ID: <4A2B7FA4.6000804@gmail.com>
Date: Sun, 07 Jun 2009 10:51:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: usb fails to suspend [was: mmotm 2009-06-05-16-19]
References: <4A2AA469.5020709@gmail.com> <1244364499.23850.83.camel@localhost.localdomain>
In-Reply-To: <1244364499.23850.83.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2009 10:48 AM, Marcel Holtmann wrote:
> Hi Jiri,

Hi.

>> $ lspci -xxvvs 0000:00:1d.2
>> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
>> Controller #3 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI
>> Controller #3
> 
> what is the likelihood that you have an Intel WiMAX card in this system?

None :) -- I have no such card in the system.

> There is a suspend issue when i2400m_usb is loaded. Took me a while to
> figure that one out. It suspends/resumes fine for the first time after
> reboot, but on resume it deadlocks the whole USB subsystem.

This was the first time I tried to suspend.
