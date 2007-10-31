Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbXJaIdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbXJaIdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbXJaId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:33:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:46009 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXJaId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QUNHtkmXuouGKumhVOBwmqiJxqjepRbjgwPtit+YgaXRWBKWpQOmV0MHoJFJjffUWIgQ34oLlflHChxgfHdjzZ3dO6Vc0aEXHDms67sAJRK3UoWFf1EYdNc8HaHz6+379NaQwW449g1HEfu7zL/7j4rFC/EbEq8CjZXVlaqXIBs=
Message-ID: <8bd0f97a0710310133m7b5cbbf3j545a489c401185df@mail.gmail.com>
Date: Wed, 31 Oct 2007 04:33:27 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 09/14] Blackfin SPI driver: Fix SPI driver to work with SPI flash ST25P16 on bf548
Cc: bryan.wu@analog.com, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Sonic Zhang" <sonic.zhang@analog.com>
In-Reply-To: <200710310011.33545.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
	 <200710301305.02640.david-b@pacbell.net>
	 <1193813431.6971.24.camel@roc-laptop>
	 <200710310011.33545.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, David Brownell <david-b@pacbell.net> wrote:
> (ISTR the M25P16 in $SUBJECT has two read commands, one of
> which is only usable at clock rates below 33 MHz or so, but
> most other commands can work above that speed just fine.)

pretty much all SPI flashes have two read commands ("slow" and "fast"
as they're typically called).  i dont think any of the linux drivers
though use the "slow" reads with any SPI flashes ... that'd be silly
:)
-mike
