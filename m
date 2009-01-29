Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZA2TWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZA2TWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZA2TWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:22:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:26357 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZA2TV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:21:59 -0500
MIME-Version: 1.0
In-Reply-To: <20090127122156.784924f4@i1501.lan.towertech.it>
References: <1233018263.14510.112.camel@localhost.localdomain>
	 <20090127122156.784924f4@i1501.lan.towertech.it>
Date: Thu, 29 Jan 2009 11:21:58 -0800
Message-ID: <9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
Subject: Re: [PATCH] x86: i2c rtc instead of cmos rtc
From: Ed Swierk <eswierk@aristanetworks.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 3:21 AM, Alessandro Zummo
<alessandro.zummo@towertech.it> wrote:
>  can't you just avoid compiling rtc cmos? or compile it as a module and
>  load the i2c rtc first?

In our embedded application it's more convenient to build all the
drivers needed to support various hardware configurations into the
kernel, and avoid messing with modules. This works fine for devices
that can be detected dynamically, but RTC chips are among the few that
need to be configured statically; my change just relaxes the current
assumption that all x86 boards have a usable CMOS RTC.

--Ed
