Return-Path: <linux-kernel-owner+w=401wt.eu-S1767387AbXDEW4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767387AbXDEW4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767402AbXDEW4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:56:07 -0400
Received: from ozlabs.org ([203.10.76.45]:51386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767387AbXDEW4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:56:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17941.32261.914571.136583@cargo.ozlabs.ibm.com>
Date: Fri, 6 Apr 2007 08:53:57 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
In-Reply-To: <1175777154.2719.14.camel@shinybook.infradead.org>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
	<20070404022544.59b022a6@the-village.bc.nu>
	<17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	<1175663999.2932.8.camel@shinybook.infradead.org>
	<17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	<1175666635.2932.17.camel@shinybook.infradead.org>
	<17939.17962.248566.886449@cargo.ozlabs.ibm.com>
	<1175696383.2774.24.camel@shinybook.infradead.org>
	<17940.14667.503535.507564@cargo.ozlabs.ibm.com>
	<1175777154.2719.14.camel@shinybook.infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:

> Of course, the _numbers_ might change -- a given port might no longer be
> ttyS0 but ttyS1. But we're happy to overlook that one even though the
> effect on the user is identical, right?

Why would the numbers be prone to change, any more than they are
already?
