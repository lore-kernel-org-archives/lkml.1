Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbXKXSr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbXKXSr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXKXSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:47:18 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:34230 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752893AbXKXSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:47:18 -0500
Date: Sat, 24 Nov 2007 19:46:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071124194635.58f5a44b@morte>
In-Reply-To: <200711241948.58881.rjw@sisk.pl>
References: <20071124175112.58193424@morte>
	<200711241948.58881.rjw@sisk.pl>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, Report='BODY_SIZE_400_499 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 19:48:58 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> NO_HZ?  Highres timers?

CONFIG_HZ_1000=y
# CONFIG_HIGH_RES_TIMERS is not set
 
> I understand that the previous kernels behave correctly.  All of them?

2.6.21 behaved correctly. Sorry but git-bisect would take a lot of time (I
can't reliably reproduce the jiffies jump), so I would avoid that if not
strictly needed.


-- 
Ciao
Stefano
