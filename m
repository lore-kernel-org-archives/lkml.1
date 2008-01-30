Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYA3GDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYA3GDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYA3GDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:03:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:41242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYA3GDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:03:11 -0500
To: Pavel Roskin <proski@gnu.org>
Cc: Jon Masters <jonathan@jonmasters.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Andi Kleen <andi@firstfloor.org>
References: <1201641765.18773.35.camel@dv> <20080129224529.4b8016c3@core>
	<1201651006.23553.8.camel@dv> <p73bq746lml.fsf@bingen.suse.de>
	<20080130050721.GB22444@dallas.jonmasters.org>
	<1201670805.4382.4.camel@rd>
Date: Wed, 30 Jan 2008 07:03:05 +0100
In-Reply-To: <1201670805.4382.4.camel@rd> (Pavel Roskin's message of "Wed\, 30 Jan 2008 00\:26\:45 -0500")
Message-ID: <p734pcv7sva.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Roskin <proski@gnu.org> writes:
>   */
> @@ -162,6 +163,7 @@ const char *print_tainted(void)
>  	if (tainted) {
>  		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
>  			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
> +			tainted & TAINT_BLOB_WRAPPER ? 'W' : ' ',


Are you sure you don't need to add a new '%c' to the format string too?
I think gcc should have warned.

-Andi

>  			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
>  			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
>  			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
>

