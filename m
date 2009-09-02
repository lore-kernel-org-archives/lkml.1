Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZIBLvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZIBLvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZIBLvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:51:45 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:47711 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZIBLvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:51:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Raphael Manfredi <Raphael_Manfredi@pobox.com>
Subject: Re: [2.6.30.5] Diagnosing an IDE lockup with SMART long tests
Date: Wed, 2 Sep 2009 13:51:32 +0200
User-Agent: KMail/1.9.10
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
References: <6661.1251822466@nice.ram.loc> <4A9DF3E9.9090309@gmail.com> <20090902111927.GA4590@chram.org>
In-Reply-To: <20090902111927.GA4590@chram.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021351.33803.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 September 2009, Raphael Manfredi wrote:
> Quoting Robert Hancock:
> > It's most likely a bug in the IDE code somewhere, but realistically the
> > most effective course of action would likely be to switch from the old
> > IDE drivers and use libata instead. The IDE code doesn't receive that
> > much testing these days, and it's really hard to debug (as you've seen,
> > the debugging output is rather atrocious).
>
> I gave it a shot anyway.  Converting to PATA was surprisingly
> straighforward.
>
> Anyway, I now get the following when running SMART long tests on /dev/sda:
>
>   ata1: lost interrupt (Status 0x50)
>
> And the machine hangs...  So I'm back to square one.
> How do I prevent lockups on the system when running SMART long tests?

What drive is that? Isn't that an IBM drive with buggy firmware?

-- 
Ondrej Zary
