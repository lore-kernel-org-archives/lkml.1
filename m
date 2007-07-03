Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbXGCXL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbXGCXL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXGCXLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:11:53 -0400
Received: from ozlabs.org ([203.10.76.45]:37207 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbXGCXLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:11:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18058.55215.185633.434117@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 09:11:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707031342.14295.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707030944.18702.oliver@neukum.org>
	<18058.12724.163599.707035@cargo.ozlabs.ibm.com>
	<200707031342.14295.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> USB devices certainly have suspend methods.

Indeed, and the USB framework has code to know when the host
controller is suspended and avoid trying to send out urbs in that
case.  Or at least it did last time I looked at it in any detail; it's
been "just working" - including suspending and resuming, without the
freezer - for quite a while now.

Paul.
