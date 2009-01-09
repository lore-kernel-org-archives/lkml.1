Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZAIVRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZAIVRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZAIVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:17:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbZAIVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:17:29 -0500
Date: Fri, 9 Jan 2009 21:17:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH post 2.6.28] firewire: core: fix sleep in atomic context
 due to driver core change
Message-ID: <20090109211718.48a7a4a6@lxorguk.ukuu.org.uk>
In-Reply-To: <tkrat.34f28fe71f678057@s5r6.in-berlin.de>
References: <496798FE.8030900@s5r6.in-berlin.de>
	<tkrat.34f28fe71f678057@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 20:49:37 +0100 (CET)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Due to commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
> create a private portion of struct device", device_initialize() can no
> longer be called from atomic contexts.

I don't see why this is neccessary or appropriate - the original commit
needs to be pulled and the private area allocation rethought.
