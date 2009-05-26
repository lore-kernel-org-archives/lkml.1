Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbZEZKfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbZEZKfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZEZKfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:35:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39414 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZEZKfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=n1UFQeqsqMa6B0+pqbsqY9EZYzVsfVr7nOdVpoJoK8NpSPOyhoPCuVrCrLsmG7UeKd
         /3FJU+nK4OTorAfW2Lg+9auyqCbxviwtEvo0KX7QQjFcPLsGB+Q6gBqOU6rH7wDx/lu2
         OKvLYMEocSCNgQrcqVeepT9so1aC8aPiBB56c=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: alejandro.riveira@gmail.com
Subject: Re: [2.6.27-rc7 vs 2.6.29 Regresion] Wifi Network Slownes rt2500pci
Date: Tue, 26 May 2009 12:35:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linville@tuxdriver.com,
       Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <1243247687.5322.8.camel@varda> <200905261058.01039.IvDoorn@gmail.com> <1243333072.4888.2.camel@varda>
In-Reply-To: <1243333072.4888.2.camel@varda>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905261235.36658.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Alejandro Riveira Fernández wrote:
> El mar, 26-05-2009 a las 10:58 +0200, Ivo van Doorn escribió:
> > On Monday 25 May 2009, Alejandro Riveira Fernández wrote:
> 
> > > Would the output of this script[2] for 2.6.29.4 with and without the
> > > revert help you ?
> > 
> > Yes please try it. but for 2.6.29 you probably need attached script instead.
> > I am not sure if it would produce something useful, because I think Johannes
> > assertion is right. With his patch the correct bitmask is send to the driver
> > and the driver actually needs _that_ bitmask without any editing
> > (rather then the incorrect one which was send before that patch).
> 
> What causes the regression then?

No idea. Apparently the invalid bitmask is accepted by the device under
certain conditions. Which would be very odd.... But since dozens
of people reported this problem for 2.6.27 as well, it probably depends
heavily on the actual chipset revision or configuration.

> Anyway For the script to work what config options do I need? debugfs?
> Anything else ?

CONFIG_DEBUGFS
CONFIG_MAC80211_DEBUGFS
CONFIG_RT2X00_LIB_DEBUGFS

And thats it, make sure debugfs is mounted and just run the script.
The script will detect mount location and rt2x00 interface.

Ivo
