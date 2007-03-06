Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbXCFH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbXCFH4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933994AbXCFH4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:56:21 -0500
Received: from main.gmane.org ([80.91.229.2]:51261 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993AbXCFH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:56:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: 06 Mar 2007 08:55:58 +0100
Message-ID: <m3k5xukdpt.fsf@ursa.amorsen.dk>
References: <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org> <20070302141840.GA3441@srcf.ucam.org> <20070302220454.a0c66d04.khali@linux-fr.org> <20070302211251.GA10035@srcf.ucam.org> <20070303105316.d51e032d.khali@linux-fr.org> <20070305222548.GA4946@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 10.8.185.213.dk-amb.res.sta.perspektivbredband.net
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
Cc: linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "PM" == Pavel Machek <pavel@ucw.cz> writes:

PM> ACPI AML is probably turing-complete: I'm afraid you are trying to
PM> solve the halting problem (-> impossible).

If you can restrict the virtual machine which AML runs in to a limited
amount of memory/storage, you can solve halting for it in exponential
time.

Unfortunately the problem here is even harder than halting. With the
halting problem you get all inputs beforehand. For AML, the locations
it accesses could be dependent on what it reads off of the hardware.


/Benny

