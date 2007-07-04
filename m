Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXGDLA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXGDLA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXGDLAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:00:16 -0400
Received: from ozlabs.org ([203.10.76.45]:54513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbXGDLAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:00:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.32169.906914.258802@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 20:59:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <200707041253.33154.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707041208.40735.oliver@neukum.org>
	<18059.31346.806801.871454@cargo.ozlabs.ibm.com>
	<200707041253.33154.oliver@neukum.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum writes:

> They can't. Device specific protocols are known to the drivers only.
> The fact remains, remove the freezer and you need to go through
> all drivers.

The freezer does not actually mean that you don't have to get the
drivers right, because kernel threads can issue I/O requests.

Paul.
