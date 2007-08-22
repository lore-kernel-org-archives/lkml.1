Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXHVJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXHVJpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbXHVJpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:50518 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbXHVJpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:45:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18124.1417.743332.974941@cargo.ozlabs.ibm.com>
Date: Wed, 22 Aug 2007 19:44:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       galak@kernel.crashing.org
Subject: Re: [PATCH] ppc: remove unused amiga_request_irq and mach_request_irq
In-Reply-To: <1187767237.25624.11.camel@sebastian.kern.oss.ntt.co.jp>
References: <1187767237.25624.11.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao writes:

> amiga_request_irq and mach_request_irq are never used, so delete them.

OK, but is there a particular reason you want to do this?

The whole of arch/ppc is going away eventually, so I don't think we
need to remove it piece by piece.

Paul.
