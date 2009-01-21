Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbZAUISr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbZAUISr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbZAUISg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:18:36 -0500
Received: from mx0.towertech.it ([213.215.222.73]:47292 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753240AbZAUISf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:18:35 -0500
Date: Wed, 21 Jan 2009 09:18:30 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Philipp Kohlbecher <xt28@gmx.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Pau Oliva Fora <pof@eslack.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       "David S. Miller" <davem@davemloft.net>,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <abelay@mit.edu>,
       Len Brown <lenb@kernel.org>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PNP IDs all uppercase
Message-ID: <20090121091830.225646d9@i1501.lan.towertech.it>
In-Reply-To: <4976D517.2070406@gmx.de>
References: <49733678.40006@gmx.de>
	<200901201742.10155.bjorn.helgaas@hp.com>
	<4976D517.2070406@gmx.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 08:56:07 +0100
Philipp Kohlbecher <xt28@gmx.de> wrote:

> switch and could not access the RTC anymore. My RTC is handled by 
> rtc-cmos, which is compiled as a module. However, udev did not load this 
> module, as the device's modalias "acpi:PNP0B00:" did not match any of 

 your main RTC should be compiled in, or you will have problems
 with fsck.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

