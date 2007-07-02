Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXGBTDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXGBTDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXGBTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:03:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:30399 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbXGBTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GsY6I58qXfE3qlePl9Z1P4k0qreKg0zhAEvEKeQchJvc2JgwFpu9DPv6F1x+JYxuoXVLTL/w8IcEDh/5dGzqWH2bnDyqPHOuYfXG5rTlnUd2GVMFVqABs3kpoFzjyry4CB9vwEiOvL7UcB+AEqJmCMMkZeu0jK2y1AAlbZMSEFY=
Message-ID: <d120d5000707021203v4cfe0d9fx560119035fa5d42a@mail.gmail.com>
Date: Mon, 2 Jul 2007 15:03:43 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: blink driver power saving
Cc: "Andi Kleen" <ak@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070702105000.73e50500@freepuppy.localdomain.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070701125035.3f54d8b0@oldman> <200707012329.52918.ak@suse.de>
	 <alpine.LFD.0.98.0707011511120.3323@woody.linux-foundation.org>
	 <200707020159.51200.ak@suse.de>
	 <20070702105000.73e50500@freepuppy.localdomain.hemminger.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>
> The patch makes sense. You don't need to poll every jiffie to find
> out if system has panic.  But I agree with Linus, it is the kind
> of patch that doesn't belong in the mainline kernel.  Every developer
> seems to have built up a set of crappy/fragile debug tools, but these
> don't belong in the wild.
>

Stephen,

The drivers blinks LEDs when kernel operates normally. During panic
the panic_blink() routine in i8042 gets called directly, without
involving the blink driver.

-- 
Dmitry
