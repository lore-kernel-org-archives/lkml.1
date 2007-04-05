Return-Path: <linux-kernel-owner+w=401wt.eu-S1767400AbXDEW76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767400AbXDEW76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767403AbXDEW76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:59:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49187 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767400AbXDEW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:59:57 -0400
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <17941.32261.914571.136583@cargo.ozlabs.ibm.com>
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
	 <17941.32261.914571.136583@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 18:59:19 -0400
Message-Id: <1175813960.2764.21.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-10.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 08:53 +1000, Paul Mackerras wrote:
> Why would the numbers be prone to change, any more than they are
> already?

Because now 8250 ports can actually coexist with Zilog ports. Before my
fix, it was strictly one or the other.

-- 
dwmw2

