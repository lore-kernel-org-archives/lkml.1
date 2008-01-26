Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYAZU4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYAZU4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYAZUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:55:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:63327 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbYAZUzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:55:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Q56cu4NM5Hch5Fc/tIRHUapux9J7jJyYSEdGZI8DqTmxAlcfQ7Vhzsm/HaeR5e5jt8Y5krQI1wfvK3ZhodV+bYiw57TSIxq6F6IRYlJl0Ch2wHugbk6t2GFxtiI5lC9xvbB87OBth3KTA/Wt1GrtBFwFJkg9IEe2Mwx0KgkX+ZQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>  (linux.* mail to news gateway)
Date: Sat, 26 Jan 2008 22:08:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <200801262043.17739.bzolnier@gmail.com> <E1JIrgj-0005cj-Gv@faramir.fjphome.nl> <Pine.LNX.4.64.0801262142300.15243@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801262142300.15243@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801262208.28859.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008, Jan Engelhardt wrote:
> 
> On Jan 26 2008 21:31, Frans Pop wrote:
> >>  config BLK_DEV_IDE_PMAC
> >> -       bool "Builtin PowerMac IDE support"
> >> +       tristate "Builtin PowerMac IDE support"

this change is no-op at the moment because the next Kconfig line is:

	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y

[ PPC-specific IDE host drivers are still a special case because they are
  using ppc_ide_md architecture hooks instead of doing proper host driver
  initialization sequence - to be fixed after adding warm-plug support... ]

> >This does not seem to make sense: if the option is now tristate, it is no
> >longer "Builtin", so probably s/Builtin // in the description.
> 
> Or something like s/Builtin/Onboard/;

Please send a patch.

Thanks,
Bart
