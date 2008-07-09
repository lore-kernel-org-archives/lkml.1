Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbYGIEua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbYGIEua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYGIEuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:50:13 -0400
Received: from ozlabs.org ([203.10.76.45]:47341 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbYGIEuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:50:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 00/11] CONFIG_KMOD removal
Date: Wed, 9 Jul 2008 12:04:59 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
References: <20080708170015.470877000@sipsolutions.net>
In-Reply-To: <20080708170015.470877000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091204.59755.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008 03:00:15 Johannes Berg wrote:
> Some place with some code or conditional I just converted to use
> CONFIG_MODULES, other places can invoke request_module unconditionally
> because it compiles out when the kernel is not modular, and one place
> (so far) converted to try_then_request_module.

Applied 1, 2, 3, 5, 9, 10 and 11.  The others had comments.

I added a help comment to the KMOD Kconfig, pointing out that it is 
deprecated.

Thanks,
Rusty.
