Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYCBLRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYCBLRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 06:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYCBLQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 06:16:56 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:50812 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753452AbYCBLQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 06:16:55 -0500
Date: Sun, 2 Mar 2008 12:04:41 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "kernel list" <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org,
       "John Linville" <linville@tuxdriver.com>
Subject: Re: Oops in mac80211:rate_control_pid_tx_status
Message-ID: <20080302120441.26c1b8a3@morte>
In-Reply-To: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
References: <2c0942db0803011705j260186bbgb02dcd8f9842e52b@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.1.325704, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.3.2.30051
X-PerlMx-Spam: No virus found, Gauge=IIIIII, Probability=26%, Report='RELAY_IN_PBL_11 2.5, SXL_IP_DYNAMIC 0.5, BODY_SIZE_600_699 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008 17:05:50 -0800
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> Kernel version 2.6.24+ a little (but pre-rc1).
> 
> I have a wireless base station that I switched from B/G mixed mode to
> purely B to try to debug a separate issue with a different device on
> my network. As soon as I did that (and on every subsequent boot), the
> system oopses as soon as it tries to associate. Switching the base
> station back to "mixed" avoids the oops.

Known and fixed. The fix is in the wireless-testing tree, and I just sent
it rebased against 2.6.25-rc3. Please test:
http://marc.info/?l=linux-wireless&m=120445495012387&w=2


--
Ciao
Stefano
