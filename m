Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYDPSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYDPSIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYDPSIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:08:31 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:22750 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbYDPSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:08:30 -0400
From: Frans Pop <elendil@planet.nl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 16 Apr 2008 20:08:26 +0200
User-Agent: KMail/1.9.9
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <20080415144748.GO7385@csclub.uwaterloo.ca> <48053AD1.8010007@gmail.com>
In-Reply-To: <48053AD1.8010007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804162008.27655.elendil@planet.nl>
X-OriginalArrivalTime: 16 Apr 2008 18:08:28.0408 (UTC) FILETIME=[DF187780:01C89FEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Tejun Heo wrote:
> Yeah, theoretically, you're right.  The problem is that what breaks when
> things go wrong.  If you don't probe generic ports by default, harddisks
> won't be detected on some legacy systems but you can always prompt the
> user about loading the generic driver.  If you probe generic ports by
> default, when things go wrong, you break modern machines in an
> unrecoverable (w/o reset) way.  I'd rather choose bothering the user on
> legacy machines.

The problem here is determining whether a machine is "legacy" or not.
So far in this discussion I've seen no suggestions how to do that (except 
maybe for my test whether /sys/bus/isa is present), which would mean asking 
_all_ users, and that's a damned ugly option.
