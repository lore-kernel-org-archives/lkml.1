Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbZIJQHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbZIJQHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIJQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:07:13 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:61394 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbZIJQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:07:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 5/6] thermal: Only set passive_delay for forced passive cooling
Date: Thu, 10 Sep 2009 18:07:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
References: <1251303445-25317-1-git-send-email-elendil@planet.nl> <1251303445-25317-6-git-send-email-elendil@planet.nl> <20090826162537.GC15868@srcf.ucam.org>
In-Reply-To: <20090826162537.GC15868@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909101807.13874.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2009 16:07:14.0280 (UTC) FILETIME=[C2E09E80:01CA3230]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wednesday 26 August 2009, Matthew Garrett wrote:
> On Wed, Aug 26, 2009 at 06:17:24PM +0200, Frans Pop wrote:
> > Setting polling_delay is useless as passive_delay has priority,
> > so the value shown in proc isn't the actual polling delay. It
> > also gives the impression to the user that he can change the
> > polling interval through proc, while in fact he can't.
> >
> > Also, unset passive_delay when the forced passive trip point is
> > unbound to allow polling to be disabled.
> >
> > Signed-off-by: Frans Pop <elendil@planet.nl>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Zhang Rui <rui.zhang@intel.com>
>
> I'll look over this - I seem to remember having some reason to set
> that, but it escapes me now.

Have you had a chance to check this?

Cheers,
FJP
