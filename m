Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbZAHRDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbZAHRDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZAHRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:03:43 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35437 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZAHRDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:03:43 -0500
Subject: Re: [PATCH] wimax: fix compile bug
From: Marcel Holtmann <marcel@holtmann.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
References: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 18:03:38 +0100
Message-Id: <1231434218.5298.19.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

> wimax should depend on INPUT:
> 
> net/built-in.o: In function `wimax_rfkill_rm':
> linux-2.6/net/wimax/op-rfkill.c:428: undefined reference to `input_unregister_device'
> net/built-in.o: In function `wimax_rfkill_add':
> linux-2.6/net/wimax/op-rfkill.c:370: undefined reference to `input_allocate_device'
> linux-2.6/net/wimax/op-rfkill.c:384: undefined reference to `input_register_device'
> linux-2.6/net/wimax/op-rfkill.c:402: undefined reference to `input_unregister_device'
> linux-2.6/net/wimax/op-rfkill.c:406: undefined reference to `input_free_device'
> net/built-in.o: In function `input_report_key':
> linux-2.6/include/linux/input.h:1285: undefined reference to `input_event'
> 
> Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

actually Inaky posted a different fix for this to netdev yesterday.

Regards

Marcel


