Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYBDUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYBDUBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYBDUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:01:35 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:37101 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbYBDUBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:01:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lx8pASnUQlgkjNnLRNqaJRC8rsDedE+6exO6R/BLwUG/K1wPbHpCGCIcICQfWcj0TluK44jVNWRK0KD6XZo/Kt1QN3r22kihF28YHBtTU30lP9bU2TgwUz/IYvJ0aPu8XnztiliIdneycYKXiYQobPwHQb9apBbkGNG/x0YS9t4=
Message-ID: <8bd0f97a0802041201w326404b6j25c20951ee35b0b6@mail.gmail.com>
Date: Mon, 4 Feb 2008 15:01:30 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [patch 0/4] cleanup - use _AC macro to define PAGE_SIZE
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, bryan.wu@analog.com, hskinnemoen@atmel.co,
       dhowells@redhat.com
In-Reply-To: <20080203122239.GF20810@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47a5a65d.03eb300a.07b8.130e@mx.google.com>
	 <20080203122239.GF20810@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 3, 2008 7:22 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sun, Feb 03, 2008 at 02:22:17PM +0300, Cyrill Gorcunov wrote:
> > This patch series removes code duplication for PAGE_SIZE
> > definition on various architectures.
> >
> > Please review. Any comments are welcome. *UNTESTED*
>
> Looks good.
> Could you do a followup patch for each architecture introducing
> use of PAGE_SIZE in their respective kernel/vmlinux.lds.S too?
> I think more than your 4 listed architectures could need this fix.

what did you have in mind exactly ?  afaik, the Blackfin linker script
should already be friendly wrt using defines instead of hardcoded
constants ...
-mike
