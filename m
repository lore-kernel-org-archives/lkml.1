Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZBWPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZBWPtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZBWPtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:49:31 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53850 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754440AbZBWPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:49:31 -0500
Date: Mon, 23 Feb 2009 10:41:08 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vegard.nossum@gmail.com
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck
 is enabled
In-Reply-To: <1235381712.6216.22.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902231039580.7298@qirst.com>
References: <1235381712.6216.22.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Pekka Enberg wrote:

> Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
> tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
> As kmemcheck is more powerful than slab debugging, disable the latter
> functionality if an user enables kmemcheck.

SLUB_DEBUG is fundamentally different from SLAB_DEBUG. It only includes
the code to be able to enable debugging at runtime. It does not enable
debugging.

