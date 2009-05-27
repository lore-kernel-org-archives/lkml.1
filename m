Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbZE0UtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbZE0UtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZE0UtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:49:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:32967 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZE0Us6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sRzihU860dr51mEYfaozHX1oFQ/XcA5AhfnZaBiZo6U73Gn/YgA2iJsZWd6V7v5obZ
         w3gd00AEfoJ6+x6UM7KaYxHr5vUsL6fBZmLDFzfuIMDK1xXXaIGKON70AqIAqiB7hJY5
         J0oaOpOq9GiIzVFNMPQGjPj6wHfuy6F0HkMsg=
Date: Wed, 27 May 2009 16:48:34 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: David Miller <davem@davemloft.net>, rmk+lkml@arm.linux.org.uk,
       devicetree-discuss@ozlabs.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       scottwood@freescale.com, yuan-bo.ye@motorola.com, timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527204834.GA3095@hansolo.jdub.homelinux.org>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> <20090527192909.GA32398@flint.arm.linux.org.uk> <20090527.132328.78091350.davem@davemloft.net> <20090527202701.GA16219@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527202701.GA16219@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:27:01PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
>On 13:23 Wed 27 May     , David Miller wrote:
>> From: Russell King <rmk+lkml@arm.linux.org.uk>
>> Date: Wed, 27 May 2009 20:29:10 +0100
>> 
>> > To program them into the hardware registers, which is not what we in
>> > the ARM community say, but it's what the _network_ guys tell people
>> > they should be doing.
>> > 
>> > I've suggested in the past having a standard kernel parameter such
>> > that you can specify a mac address on a per-device basis in a totally
>> > platform independent way, but the network folk don't like that idea.
>> 
>> As a "network guy" I can tell you that when the system firmware
>> provides a system-wide or device specific MAC address in it's device
>> tree, that is what you should use.
>> 
>> And that's what I've been doing on sparc FOR 15 YEARS.
>> 
>> Device trees are the only systematic generic mechanism for
>> describing device layouts on the myriad of embedded boards
>> out there which you will ever find.
>> 
>> Two platforms, and now a third, have been using this scheme
>> over a very proven period of time.  It's not a hack, there is
>> infrastructure to get the boot loaders to do the right thing,
>> and only ARM seems to resist it. :-)
>The SH, avr32, mips, x86 does not support it too IIRC

x86 has a variant.  The OLPC uses OF.

josh
