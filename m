Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYK2Myp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYK2Myp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 07:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYK2Myg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 07:54:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:33474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYK2Myg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 07:54:36 -0500
From: Andreas Schwab <schwab@suse.de>
To: roel kluin <roel.kluin@gmail.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs,si}_close() both unsigned hp->count and hvcsd->open_count cannot be negative
References: <4931201D.7060701@gmail.com>
X-Yow: Now KEN is having a MENTAL CRISIS because his "R.V." PAYMENTS are
 OVER-DUE!!
Date: Sat, 29 Nov 2008 13:54:31 +0100
In-Reply-To: <4931201D.7060701@gmail.com> (roel kluin's message of "Sat, 29
	Nov 2008 05:57:33 -0500")
Message-ID: <jey6z24rqw.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin <roel.kluin@gmail.com> writes:

> -	if (--hvcsd->open_count == 0) {
> +	if (hvcsd->open_count == 1) {
> +		hvcsd->open_count--;

This is not the same.

> -	if (--hp->count == 0) {
> +	if (hp->count == 1) {
> +		hp->count--;

Likewise.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
