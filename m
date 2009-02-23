Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZBWRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZBWRdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZBWRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:33:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46119 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZBWRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:33:29 -0500
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when
	kmemcheck is enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vegard.nossum@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902231039580.7298@qirst.com>
References: <1235381712.6216.22.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902231039580.7298@qirst.com>
Date: Mon, 23 Feb 2009 19:33:26 +0200
Message-Id: <1235410406.6216.69.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 10:41 -0500, Christoph Lameter wrote:
> On Mon, 23 Feb 2009, Pekka Enberg wrote:
> 
> > Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
> > tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
> > As kmemcheck is more powerful than slab debugging, disable the latter
> > functionality if an user enables kmemcheck.
> 
> SLUB_DEBUG is fundamentally different from SLAB_DEBUG. It only includes
> the code to be able to enable debugging at runtime. It does not enable
> debugging.

Yes, I know that but we can't really let the user enable both, slub
debugging and kmemcheck debugging, at run-time. That's why I used
SLUB_DEBUG here.

