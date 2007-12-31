Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXLaJzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXLaJzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 04:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXLaJy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 04:54:56 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:55779 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXLaJyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 04:54:55 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Mon, 31 Dec 2007 10:54:52 +0100
Subject: Re: RAID timeout parameter accessibility request
From: Jose de la Mancha <hidalgoj@free.fr>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C39E7AFC.F5C7%hidalgoj@free.fr>
Thread-Topic: RAID timeout parameter accessibility request
Thread-Index: AchLkzAjbm21IbeGEdyZCAADk7o1Ig==
In-Reply-To: <4778256E.5000309@shaw.ca>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks guys for your answers (please remember to keep CCing me).

Robert Hancock wrote:
> This always seemed a strange use case to me. If the drive is getting
> read errors, either it's dying and needs to be replaced, or it has a
> sporadic bad sector as a result of a power failure during write, etc. in
> which case the drive should be resynchronized. In either case the drive
> should be dropped from the array and require manual intervention. It
> doesn't seem logical to me to just read the data from another drive and
> carry on in our merry way without any warning.

--> A warning message is OK, but dropping the drive from the array is
excessive IMHO. And anyway, this should be user-configurable, so that it
becomes each user's responsibility to choose if the drive shall be dropped
or not. Currently we don't have any choice.

Jan Engelhardt wrote:
> Not sure about Debian, but perhaps /sys/block/md0/md/safe_mode_delay
> does something?

--> I'll check that out. Does someone know about how this "safe mode delay"
works ?

Thanasis wrote:
> WD 2500YS
> price same as an IDE or SATA

--> All RAID edition drives are more expensive that their equivalent
"desktop edition" drives (same model on "desktop edition"). Just take a look
at newegg for instance. Besides, trying to find an affordable "RAID edition"
model is not a solution to this technical timeout issue, just a workaraound
(a bad one IMHO). Thanks anyway.


