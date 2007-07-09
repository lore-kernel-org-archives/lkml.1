Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXGIHQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXGIHQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXGIHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:16:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57661 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXGIHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:16:43 -0400
Date: Mon, 9 Jul 2007 09:16:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
Message-ID: <20070709071640.GB10864@one.firstfloor.org>
References: <11838956891287-git-send-email-avi@qumranet.com> <11838956893094-git-send-email-avi@qumranet.com> <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4691D9C1.4050309@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, smp_call_function_single() is arch specific whereas on_cpu() is

Yes, but the few instances should be relatively easy to fix.

> generic code.  Perhaps rename smp_call_function_single() to
> __smp_call_function_single() and on_cpu() to smp_call_function_single()?

The low level function checks for this anyways. Instead of erroring
it should just DTRT.

> 
> I dislike the loss of symmetry though.

on_each_cpu() was imho always a mistake. It would have been better
to just fix smp_call_function() directly

-Andi

