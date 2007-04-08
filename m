Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXDHUuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXDHUuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 16:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXDHUuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 16:50:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbXDHUuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 16:50:51 -0400
Date: Sun, 8 Apr 2007 13:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Kaindl <bk@suse.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/4] Fix MTRR suspend support for specific machines
 (some AMD64, maybe others also)
Message-Id: <20070408135024.83e2f5f6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
	<200703272213.51947.ak@suse.de>
	<Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
	<200703291525.59116.ak@suse.de>
	<Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007 15:55:32 +0200 (CEST) Bernhard Kaindl <bk@suse.de> wrote:

> With at least 3 of the following 4 patches, s2ram and s2disk are
> fixed on at least the Acer Ferrari 1000 notebooks and at least
> s2disk on the Acer Ferrari 5000 notebooks.

These patches cause my Vaio to oops during suspend-to-disk.

oops: http://userweb.kernel.org/~akpm/s5000499.jpg
config: http://userweb.kernel.org/~akpm/config-sony.txt

