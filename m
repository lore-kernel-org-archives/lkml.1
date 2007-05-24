Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbXEXIr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbXEXIr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbXEXIrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:47:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:58537 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEXIrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KhhVyscU3/bkiCAVE4YYrnSB93cWR1PhM39ZRFtXB8+d3fyu8V09q8kFoycIzEIFuzOpO8/FO6WHD2UjOaOvvPnyg6uHNe6IcODyIl5gxCbRuttM4Ux0JL16b+kOUCDRr6t84U7QBRHVWSjvSQNuirdH3D/zyiDl0BktDsLmuF0=
Message-ID: <ba1ee50c0705240147t3d2ebf43w8cb0335bc7c239e4@mail.gmail.com>
Date: Thu, 24 May 2007 03:47:45 -0500
From: "Daniel Newby" <daniel.a.newby@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
In-Reply-To: <20070524052312.GA2447@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com>
	 <20070524052312.GA2447@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
>  It sounds like your constraining your driver based on terminology.
> Watchdogs on most embedded platforms support either a 'reset' mode or
> otherwise act as periodic timers, trying to push both of these
> functionalities in to a watchdog driver is rather pointless.
> CONFIG_WATCHDOG implies 'reset' mode by definition.

I agree for a product in the hands of a customer:  let the watchdog
pull your bacon out of the fire.

But what about debugging?  Suppose your embedded computer with custom
drivers locks up solid every few hundred hours.  It would be nice if
the watchdog gave a stack dump instead erasing the evidence.  How about
having "action=reset" and "action=debug"?

    -- Daniel
