Return-Path: <linux-kernel-owner+w=401wt.eu-S1757940AbZGGN60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbZGGN60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZGGN6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:58:16 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45852 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbZGGN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V24v7UZHH9wkVKwQpaSMzDAr+o0MDmOmQSdAUJL/tlbvRHs2wpXBSKyavHDAhR5yq8
         qObJ9TUmmIOfAZIbyIl90xqj4qgo9vvAV+Fb/dllR5gtM/dJmytIzQDE6ifBWIAedxW4
         zZM/Ffb1Rdzj/4NIkGpRlm8QEntDY6gSER68E=
Date: Tue, 7 Jul 2009 15:57:42 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090707135742.GB6798@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <200907071522.06812.andres@anarazel.de> <20090707132937.GA6798@ami.dom.local> <200907071534.07619.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907071534.07619.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 03:34:07PM +0200, Andres Freund wrote:
...
> Testing wether its triggerable inside a vm might be interesting...

Probably similarly to testing without this patch or even less. Maybe
I should've warned you but this type of bugs in -rc with possible
memory or stack overwrites might be fatal for your data (at least).

Jarek P.
