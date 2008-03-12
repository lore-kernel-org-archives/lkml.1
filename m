Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYCLXD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYCLXD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYCLXCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:02:50 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:31779 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754275AbYCLXCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:02:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4eEfajxiAEHXhDyS366HAa0SNctturkxI8sZ/YgDYuu3CWGR5VD4cgrRwLx0lAtlYikl7Pate7A+Y2yExn38c5PwVMj6jHyy1WnV1mCDMtlN/em+JVQDiDmegubBhfakHiftyyfmPus5QAxyWiBn56SMfGzn5ASmtVNf90ATues=  ;
X-YMail-OSG: 1eIFvTwVM1nIrnc1EL0JPTcgbRCHVSRy7tuo5PVjUGWseB1c
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 2/3] gpiolib: implement gpiochip_reserve
Date: Wed, 12 Mar 2008 14:59:12 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080311174118.GB12397@localhost.localdomain> <200803111411.38287.david-b@pacbell.net> <20080312122315.GA500@localhost.localdomain>
In-Reply-To: <20080312122315.GA500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121559.13342.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Anton Vorontsov wrote:
> > It
> > presumes the reserved bits and gpio chips are in fairly
> > close synch.
> 
> Probably I don't understand the synch part here. The thing is that
> I'm replacing if (!chip) with if (!chip && !test_bit(FLAG_RESERVED,
> &desc->flags)), so now "else" code might be executed when gpio is
> either reserved or the range of gpios is already managed by the chip.

OK then.


> Below the patch with __init attribute added.
> 
> - - - -
> From: Anton Vorontsov <avorontsov@ru.mvista.com>
> Subject: gpiolib: implement gpiochip_reserve
> 
> Function gpiochip_reserve() reserves range of gpios to use with
> platform code only, that is, this function used to mark specified
> range of gpios unavailable for the dynamic gpio base allocator.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  ...
