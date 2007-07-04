Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbXGDI17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbXGDI17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbXGDI1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:27:51 -0400
Received: from ozlabs.org ([203.10.76.45]:56608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbXGDI1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:27:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18059.23015.860618.268754@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 18:27:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041011.33279.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031342.14295.oliver@neukum.org>
	<18058.55215.185633.434117@cargo.ozlabs.ibm.com>
	<200707041011.33279.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> > Indeed, and the USB framework has code to know when the host
> > controller is suspended and avoid trying to send out urbs in that
> > case.  Or at least it did last time I looked at it in any detail; it's
> > been "just working" - including suspending and resuming, without the
> > freezer - for quite a while now.
> 
> And what happens to that IO? I suspended and lost data is not an
> acceptable behavior.

It's not lost, it's sitting in RAM, and will be sent out when you
resume.

Paul.
