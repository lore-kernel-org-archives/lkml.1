Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZELUaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZELUaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZELU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:29:54 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57715 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZELU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rJm891ZewpszQi39QYXvWLa95uUHE5+yoUX9FPrFyv92zqkryfBa2UWVaBOWHpGKM0
         ZWR+TLYEHQIQXnp5a1HYhpFXzyHZ88ZHu8ru53GwcCafVhlAZ3Gj8BxIRMLzi4nE6AdD
         qrZw2IeW7LjIB14T6R1bjmRiJ6lwojzmNVIrs=
Message-ID: <4A09DC3E.2080807@googlemail.com>
Date: Tue, 12 May 2009 22:29:50 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: David Dillow <dave@thedillows.org>
CC: Michael Buesch <mb@bu3sch.de>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <1242001754.4093.12.camel@obelisk.thedillows.org> <200905112248.44868.mb@bu3sch.de> <200905112310.08534.mb@bu3sch.de> <1242077392.3716.15.camel@lap75545.ornl.gov>
In-Reply-To: <1242077392.3716.15.camel@lap75545.ornl.gov>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

David Dillow wrote:

> I was saying that I don't think the timeouts are necessarily the NIC
> chipset -- or the bridge chip for that matter --  having issues with
> MSI. There were some substantial IRQ handling changes in 2.6.28 and my
> bisection of the problem seem to lead into that code. I'll try this
> later tonight hopefully, but can you try to run 2.6.27 with the current
> r8169 driver and see if it is solid for you? That way it is using the
> same driver code, but avoids the IRQ changes.

Unfortunately, 2.6.27 won't build with r8169.c copied from 2.6.29.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
