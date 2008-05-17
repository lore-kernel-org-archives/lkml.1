Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYEQQAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYEQQAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 12:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYEQP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:59:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYEQP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:59:40 -0400
Message-ID: <482F0041.6070208@zytor.com>
Date: Sat, 17 May 2008 08:56:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Johannes Berg <johannes@sipsolutions.net>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
References: <482C8595.5030509@garzik.org> <200805171628.03801.rusty@rustcorp.com.au> <20080517064307.GA16857@gondor.apana.org.au> <200805170943.54031.borntraeger@de.ibm.com>
In-Reply-To: <200805170943.54031.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> I think the proper solution would be to use the hosts /dev/hw_rng - if 
> available.

Not really, no.  The host has access to real entropy in the form of 
hardware timings as well as possibly /dev/hw_rng.

	-hpa
