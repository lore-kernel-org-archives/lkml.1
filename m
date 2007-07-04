Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXGDFDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXGDFDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbXGDFDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:03:01 -0400
Received: from ozlabs.org ([203.10.76.45]:37499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177AbXGDFC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:02:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.5165.861038.392332@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 13:29:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
In-Reply-To: <200707032332.49694.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031456.40890.rjw@sisk.pl>
	<1183497290.3388.4.camel@localhost.localdomain>
	<200707032332.49694.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki writes:

> Still, do you really think that we're ready to drop it _right_ _now_ (I'm
> referring to suspend only) and if so than on what basis (except that you
> don't like it, which falls short of being a techical argument)?

The basis is that it (the freezer) causes more deadlocks and other
problems than it avoids, so it's a net win to remove it.

Paul.
