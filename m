Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbZGIHLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbZGIHLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZGIHLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:11:17 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:51948 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZGIHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sxShh9mEtYOECid1qkmKrcrw5TLI7pAWZcZHAYP3Razr7rSHZwXKyEd+8iQIFAx4/Z
         KMpQM5WCcnCXTX0ESu7y6dtyR2rB67G4Kf/4rP6UQ2trMsIfCNA1VeSzuQ5Kbs1+XB1L
         /2zscieWR4OOfAvidhA/hc7hzf6o1kjv7k81c=
MIME-Version: 1.0
In-Reply-To: <200907090905.27154.hs4233@mail.mn-solutions.de>
References: <200907082340.07787.elendil@planet.nl> <43e72e890907081508n6fa5781an1dcbda078efc5379@mail.gmail.com> 
	<200907090905.27154.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Jul 2009 00:10:52 -0700
Message-ID: <43e72e890907090010y2ebd4f2bvd5fe5612084fe6df@mail.gmail.com>
Subject: Re: [regression] ath5k: Overrides regulatory domain set for cfg80211
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, Frans Pop <elendil@planet.nl>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 12:05 AM, Holger
Schurig<hs4233@mail.mn-solutions.de> wrote:
>> Eventually, as you will read from the feature-removal
>> schedule, we intend on getting the Linux desktop to provide
>> automatic hints of the user's location through things like
>> GeoClue.
>
> Please think about embedded people. We don't need no stinkin'
> geoclue. We'll need a kernel parameter or an commant for "iw" or
> some other netlink based command.

Note I wrote "Linux desktop" not Linux embedded. And we already have a
nl80211 command for this exact purpose. You can even use
wpa_supplicant if you don't want to use iw.

I wouldn't be surprised to see geoclue in embedded devices though.

  Luis
