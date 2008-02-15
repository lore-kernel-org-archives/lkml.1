Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbYBORze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbYBORze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYBORz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:55:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31585 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbYBORzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nxvPvbljz2Zn2z7FcMpdwBM9w9uHW2nMom8gknT5Rrr7XuwopJjaAYOHGhjcVAPFqKMnkoj2Z6Sn3GqSrfXU6eFBNpg500BKsU+ubgZvw4CRsKztM6fb5ulG/c/PINNBzPOko0g+BIWn+EjFeMkiAO1CkKGoawRBZJmi0idHC98=
Message-ID: <4779de450802150955m17c42d96j809804c3c0b99a4@mail.gmail.com>
Date: Fri, 15 Feb 2008 09:55:24 -0800
From: "Dan Gora" <dan.gora@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: PCI Bursting with PIO
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73abm21ocl.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>
	 <p73abm21ocl.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:54 AM, Andi Kleen <andi@firstfloor.org> wrote:
> "Dan Gora" <dan.gora@gmail.com> writes:
>  >
>  > Is there any way to get PIO
>
>  I assume you really mean MMIO, not PIO. PIO would be port IO.

Sorry, I always saw it referred to as "Programmed I/O" as opposed to DMA...

>  You should set the MMIO mapping to write combining using an MTRR

Sorry to be thick here, but how would  I go about doing that?

>  You might need to add appropiate memory barriers if you rely
>  on write ordering though.

Ok, thanks for the info...

dan
