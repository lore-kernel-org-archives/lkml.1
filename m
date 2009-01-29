Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZA2TlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZA2TlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZA2TlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:41:10 -0500
Received: from mx0.towertech.it ([213.215.222.73]:33017 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753190AbZA2TlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:41:09 -0500
Date: Thu, 29 Jan 2009 20:41:04 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: eswierk@aristanetworks.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] x86: i2c rtc instead of cmos rtc
Message-ID: <20090129204104.60bf46a2@i1501.lan.towertech.it>
In-Reply-To: <9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
References: <1233018263.14510.112.camel@localhost.localdomain>
	<20090127122156.784924f4@i1501.lan.towertech.it>
	<9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 11:21:58 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> In our embedded application it's more convenient to build all the
> drivers needed to support various hardware configurations into the
> kernel, and avoid messing with modules. This works fine for devices
> that can be detected dynamically, but RTC chips are among the few that
> need to be configured statically; my change just relaxes the current
> assumption that all x86 boards have a usable CMOS RTC.

 While I can't judge on what's convenient to you, I do not feel
 fine in having a kernel option to disable the rtc and another to load
 a specific i2c one.

 However, if there's a strong consensus from other people
 on the matter, I will close an eye and pretend I haven't seen
 the patch slipping thru :)


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

