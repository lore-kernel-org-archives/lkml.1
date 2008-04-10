Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYDJLQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYDJLQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDJLQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:16:13 -0400
Received: from hs-out-0708.google.com ([64.233.178.245]:44377 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYDJLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZKM1faXrWTJhRpX9n/u6sPMa1s84ixA/c13x/9sn/gaffVU0EBcOmn0WH8hkDEgl6BC9PXDTxf3flqTuQTtE8c3/pGEGcVBTXSZtGlHEOLvmPiA126ogbkHjL4pXwyehoqgtJIMovRL+y1+dTzjWEXiHJgGvDKI1YnmZA3NsBMs=
Message-ID: <c4e36d110804100416y3634505dy56e7341495d10d91@mail.gmail.com>
Date: Thu, 10 Apr 2008 13:16:10 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Andi Kleen" <andi@firstfloor.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0804081009040.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
	 <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz>
	 <20080407222352.GG16647@one.firstfloor.org>
	 <200804080029.31102.rjw@sisk.pl>
	 <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
	 <c4e36d110804071553x6ce219b2tc1e27ce5d3a722af@mail.gmail.com>
	 <Pine.LNX.4.64.0804081009040.3896@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/8, Jiri Kosina <jkosina@suse.cz>:
> On Tue, 8 Apr 2008, Zdenek Kabelac wrote:
>
>  > To avoid some mystery - these two warns precede warnings I've initially
>  > posted here - the reason why I've not posted also these 2 kvm related
>  > warns is that kvm maintainers already know about this problem and said
>  > in the past that they will eventually fix them (If I remember correctly)
>  > Warnings and bug looked somewhat unrelated - but I could be wrong and
>  > the mystery irq could be mangles in kvm....
>
>
> Yes, please try to reproduce without KVM. It could happen that some KVM
>  code wrongly enabled IRQs somewhere.

Well I'm unable to simulate this warning message - it happened to me
once even with kvm, so for now I have no idea how to easily replicate
this problem. But I'll keep an eye on this.

Zdenek
