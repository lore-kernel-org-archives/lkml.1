Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbYETXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbYETXVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYETXVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:21:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26185 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYETXVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R3ROPzZ0URHSvoAWvrCHXViiBe0xl5yhXZ8SQ4Kw5tcS+reEqZd13n2qYP6S+NN3a1Z9duzNfaxVT7sWCUd9hal/8exlchqs47vCFkW820r5fQpotJGcRI4TuLOuSf7SF1PuDl+iJ8o/f+W1AuYHthvg+p3sVhsRFyhsH6uAuKw=
Message-ID: <8bd0f97a0805201621j449ad2a5s7c24e1a48c3aa31c@mail.gmail.com>
Date: Tue, 20 May 2008 19:21:03 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
Cc: "Javier Herrero" <jherrero@hvsistemas.es>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <20080520231323.GA10750@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520073556.GA1090@flint.arm.linux.org.uk>
	 <483286AF.2090302@hvsistemas.es>
	 <20080520083217.GA10172@flint.arm.linux.org.uk>
	 <4832AD84.6090300@hvsistemas.es>
	 <20080520231323.GA10750@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 7:13 PM, Russell King wrote:
> On Tue, May 20, 2008 at 12:52:52PM +0200, Javier Herrero wrote:
>> I see... would be OK to move the asm/serial.h include to its original
>> position and to modify the asm-blackfin/serial.h in this way to avoid
>> duplicate definition warnings, or would it be too ugly?:
>
> Can blackfin systems accept PCMCIA cards?  Or PCI cards?  In which case
> you probably don't want to implement this support like this.

yes, you can hook PCMCIA cards up to a Blackfin proc (and we have).
we probably wont be supporting PCI since it tends to require MMU
support, and at least with all the Blackfins we support now, none have
PCI support on-chip.
-mike
