Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbXJCHIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbXJCHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXJCHIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 03:08:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbXJCHIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 03:08:30 -0400
Date: Wed, 3 Oct 2007 09:08:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [bootup warning] "driver" has no release callback, .23-rc9
Message-ID: <20071003070816.GA1208@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, there are 7 V4L drivers that produce this (non-fatal) warning:

[ 132.060848] videodev: "vivi" has no release callback. Please fix your 
driver for proper sysfs support, see http://lwn.net/Articles/36850/

[ 132.124436] videodev: "Aztech radio" has no release callback. Please 
fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

[ 135.685993] videodev: "Typhoon Radio" has no release callback. Please 
fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

[ 135.752619] videodev: "TerraTec ActiveRadio" has no release callback. 
Please fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

[ 135.874244] videodev: "RadioTrack radio" has no release callback. 
Please fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

[ 167.937597] videodev: "Zoltrix Radio Plus" has no release callback. 
Please fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

[ 168.021325] videodev: "GemTek radio" has no release callback. Please 
fix your driver for proper sysfs support, see 
http://lwn.net/Articles/36850/

	Ingo
