Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbXBFQF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbXBFQF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbXBFQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:05:29 -0500
Received: from ns2.mvista.com ([63.81.120.158]:47081 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbXBFQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:05:27 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
References: <20070129204528.eb8d695e.akpm@osdl.org>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 08:03:22 -0800
Message-Id: <1170777802.9781.353.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It appears there a problem with the /proc/interrupts entry for
"timer" .. It doesn't increment anymore .. This problem exists in the
-rt tree also .. I haven't done a bisect , but I'm assuming this is HRT
related ..

Also my NMI watchdog isn't functioning , which also exists in the -rt
tree, and -mm .. Also likely HRT related ..

I don't have HRT or dynamic tick turned on .. This started happening in
-mm2 , and it worked in -mm1 ..

Daniel

