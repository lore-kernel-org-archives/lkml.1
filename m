Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYHTU1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYHTU1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYHTU1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:27:14 -0400
Received: from cpsmtpo-eml06.kpnxchange.com ([213.75.38.155]:8963 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbYHTU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:27:13 -0400
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
Date: Wed, 20 Aug 2008 22:26:45 +0200
User-Agent: KMail/1.9.9
References: <200808202106.41058.elendil@planet.nl> <200808202138.13302.rjw@sisk.pl>
In-Reply-To: <200808202138.13302.rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808202226.45655.elendil@planet.nl>
X-OriginalArrivalTime: 20 Aug 2008 20:27:10.0968 (UTC) FILETIME=[1FC6D780:01C90303]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick responses Rafael.

On Wednesday 20 August 2008, Rafael wrote:
> On Wednesday, 20 of August 2008, Frans Pop wrote:
> > <snip>
> > CPU1 is up
> > ACPI: Waking up from system sleep state S3
> > APIC error on CPU1: 00(40)
> > ACPI: EC: non-query interrupt received, switching to interrupt mode
> > </snip>
>
> Does the box work after that?

Yes, it does. Both cores seem to be working fine.

The only weirdness I can see (only spotted that just now) is that both 
cores will always seem to be changing frequency together (using ondemand 
governor), even when 'top' shows one as idle. On my other Core Duo system 
(an older desktop) the cores react independently.
This also happens immediately after boot (so not suspend related) and may 
be "normal" or unrelated.
