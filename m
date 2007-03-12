Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXCLAZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXCLAZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXCLAZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:25:49 -0400
Received: from gw.goop.org ([64.81.55.164]:39435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXCLAZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:25:48 -0400
Message-ID: <45F49E0A.3090607@goop.org>
Date: Sun, 11 Mar 2007 17:25:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: _proxy_pda still makes linking modules fail
References: <1173315479.12472.9.camel@qrnik> <p73lki39s3a.fsf@bingen.suse.de>
In-Reply-To: <p73lki39s3a.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hmm, it probably needs a EXPORT_SYMBOL. The previous change only
> fixed the in kernel build.
>
> Does it work with this patch?
>
> -Andi
>
> Export _proxy_pda for gcc 4.2
>   

Gak.  It seemed like such a good idea at the time.

Rusty's pda->per_cpu patch will deal with this once and for all; have
you picked it up yet?

    J
