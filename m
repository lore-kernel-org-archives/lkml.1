Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZCWKK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZCWKK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZCWKKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:10:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:43990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755254AbZCWKKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:10:44 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+wY0U7NFuwq7WW9gyNNHFQWMU6+jf4962ayLUjhF
	05gQZeScqEfR8V
Date: Mon, 23 Mar 2009 11:10:49 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 0/3 v2] ipu_idmac: code clean-up and robustness improvements
In-Reply-To: <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0903231106060.4871@axis700.grange>
References: <Pine.LNX.4.64.0903130837040.4653@axis700.grange>
 <e9c3a7c20903161459n8ad3c6qd705d146703b28a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Dan Williams wrote:

> On Fri, Mar 13, 2009 at 12:41 AM, Guennadi Liakhovetski <lg@denx.de> wrote:
> > General code clean-up: remove superfluous semicolons, update comments.
> > Robustness improvements: add DMA error handling to the ISR, move common code
> > fragments to functions, fix scatter-gather element queuing in the ISR, survive
> > channel freeing and re-allocation in a quick succession.
> >
> > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > ---
> >
> > Dan, I've been using this patch for a while, without any need for a
> > change, so, it should be fine to go upstream.
> >
> 
> Are you sure that we will never want to bisect in between these
> several topics?  I would feel more comfortable with at least the fixes
> separated from the code refactoring/pure additions.

Ok, now split.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
