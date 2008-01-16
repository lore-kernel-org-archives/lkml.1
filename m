Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYAPM0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYAPM0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYAPM0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:26:32 -0500
Received: from ozlabs.org ([203.10.76.45]:49592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYAPM0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:26:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "rae l" <crquan@gmail.com>
Subject: Re: [RFC on MODULE SUPPORT] hello, Rusty, Should we provide module information even if the kernel module compiled built-in with bzImage?
Date: Wed, 16 Jan 2008 23:25:54 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org
References: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
In-Reply-To: <91b13c310801160202y833df7bs37cbb5827e875569@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801162325.54326.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 21:02:22 rae l wrote:
> hello, Rusty:

Hi Denis.

> Should we provide module information under
> /sys/module/<module-name>/... even if the module compiled built-in
> with bzImage?

Absolutely.  Module parameters (should) already do that, for example.

> Or just this module(scsi_transport_iscsi) should be marked with [M] only?
>
> if the former solution is preferred, I would be happy to work on
> MODULE_INFO-like macros improvements with CONFIG_MODULE undefined.

I'd love to see patches.  module_parm showed it's possible, if messy.

Thanks!
Rusty.
