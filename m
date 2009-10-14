Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbZJNNwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbZJNNwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760189AbZJNNwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:52:39 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:37498 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbZJNNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vQeVH7UbdgKamDuX/o58cpWLbi9IvzB626BPYz2XNbLms3QEMUFJKTkUcy+cL/ebWf
         p5IplLX/S4ZYsC5rRzzMUMfjiOlVScI6KM/zaPmBvZdk+R0OSd8b7QJK+OdTgJb27GZg
         9ImPBkbTHHnb0SqAcumvvHXx/7dFErrd4AfZU=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Current status of rt2800usb and staging/rt2870
Date: Wed, 14 Oct 2009 15:51:56 +0200
User-Agent: KMail/1.9.10
Cc: Dan Williams <dcbw@redhat.com>,
       Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4AD46380.9020308@pardus.org.tr> <1255464940.10798.10.camel@localhost.localdomain> <200910132357.57094.bzolnier@gmail.com>
In-Reply-To: <200910132357.57094.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910141551.56711.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1) the vendor driver never gets converted to cfg80211/mac80211, and
> > stays in staging forever, or finally gets booted out of staging because
> > nobody is working on converting it to mac80211.  mac80211/cfg80211 is a
> > hard requirement for being an accepted wireless driver.  And drivers do
> > have a shelf-life in staging.
> > 
> > 2) the vendor driver starts getting converted to use mac80211.  But I
> > would argue that a better use of *anyone's* time is to make rt2x00
> > better, instead of porting the ralink vendor drivers to mac80211.  It
> > would probably take less time to fix up rt2x00 for new hardware than to
> > port the ralink vendor drivers to mac80211.
> 
> Nobody is saying anything about porting the vendor drivers to mac80211.
> 
> 3) After the vendor driver gets cleaned up to the point that people are
> able to make any sense out of it the missing bits will get added to rt2x00.
> Several months later (after all current users are happy with the improved
> drivers) the old drivers will be removed from staging..

Wishful thinking. the Ralink drivers for rt2460, rt2560, rt2570, rt61 and rt73
coexisted for years with their rt2x00 counterparts before they were finally
abandoned after many arguments from people which wanted to preserve
those drivers for even more years.

Ivo
