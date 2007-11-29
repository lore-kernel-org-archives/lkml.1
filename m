Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXK2BdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXK2BdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762175AbXK2Bcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:32:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbXK2Bcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:32:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Date: Thu, 29 Nov 2007 02:32:46 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20071127001407.859743255@sgi.com> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com> <474E163E.2070702@goop.org>
In-Reply-To: <474E163E.2070702@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711290232.47141.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>     * drop support for stack-protector (does it really help? do people
>       use it?)

AFAIK we only ever had a single classical stack buffer overflow in the kernel.
It certainly doesn't seem to be a common security problem it is solving.

-Andi
