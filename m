Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZGYUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZGYUW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 16:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZGYUW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 16:22:29 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:52458 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbZGYUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 16:22:28 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH -tip][RFC] serial8250: update to dev_pm_ops
Date: Sat, 25 Jul 2009 22:22:26 +0200
User-Agent: KMail/1.9.9
Cc: Erik Ekman <erik@kryo.se>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090701083737.41f28c7d.erik@kryo.se> <20090708144337.7006fa0a@t61.ukuu.org.uk> <200907251612.34140.elendil@planet.nl>
In-Reply-To: <200907251612.34140.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907252222.28189.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 20:22:28.0778 (UTC) FILETIME=[A19D50A0:01CA0D65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Frans Pop wrote:
> On Wednesday 08 July 2009, Alan Cox wrote:
> > On Wed, 8 Jul 2009 Frans Pop <elendil@planet.nl> wrote:
> > > > From dmesg:
> > > > Platform driver 'serial8250' needs updating - please use
> > > > dev_pm_ops
> > > >
> > > > Is this how it should be done?
> > >
> > > Alan or Rafael can probably tell.
> >
> > No idea. I've not looked at this so your guess is as good as mine
> > (but looks quite believable. I don't plan to do anything until
> > someone who needs platform 8250 support sends a tested version of the
> > change however.
>
> I have done a few of these myself now and followed all other similar
> updates for other drivers. From that experience I can say that this
> update is both trivial and correct. Hope you will reconsider your
> reluctance on that basis.

Please cancel that. It turns out that the old system also supported 
suspend to disk, which most driver conversions so far did not allow for.

Kudo's to Dmitry Torokhov for bringing this up.

Sorry.
