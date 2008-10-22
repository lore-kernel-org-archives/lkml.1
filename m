Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbYJVU4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbYJVU4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYJVU4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:56:21 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36120 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYJVU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=gqidNfmFKyNAzlUtC9cCHM0ciBorw1XsIhk5UZ/+GjOV98cl1vF1JO3WZJU+UlQcyB
         liaJTf0DhEhuDI1s1m5uwF6WeVpBrrY7Do9uBH0mfeezZW6WHBCDydWI/G0y+pc2R30g
         P5GJnrRIbOElA+tWOcBx/fLUTs2q3amHmN+vs=
Message-ID: <d9def9db0810221356u1ff85578qcc874dd1e58f7fae@mail.gmail.com>
Date: Wed, 22 Oct 2008 22:56:19 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: linux-kernel@vger.kernel.org, em28xx@mcentral.de
Subject: [Patch 0/7] Add em28xx driver from mcentral.de
Cc: acano@fastmail.fm, "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got adviced to submit the drivers independently.
this patch adds support for all outstanding em28xx devices which are
currently supported on mcentral.de (at least 40 devices).

a small summary:
* adding VBI support to em28xx based devices (for tvp5150 based
devices this depends on a recently submitted patch to linuxtv.org)
* stereo FM radio support for cx25843 based devices
* extra cx25843 driver (registers match the em28xx configuration in
order to support proper VBI)
* all videostandards and inputs are tested with cx25843 based devices,
successful firmware reloading after switching back from a certain mode
* adding alternative audio driver for em28xx devices (independent
audio transfer, not depending on oss/alsa)
* adding em28xx-webcam support for videology webcams
* adding em28xx-audioep audio driver for alternate number 1 - if
vendor specific and not USB audio conform
* adding sharp s921 chip driver (ISDB-T 1Seg support tunneling
parameters through DVB-T API setting specific registers to auto)
* adding xc3028 mostly original sourcecode from the manufacturer (most
recent version), merged xc3028/xc3028l into
  one external firmware blob - important for signal quality
* adding xc5000 mostly original sourcecode from the manufacturer (most
recent version) - important for signal quality
* adding lgdt3304, although currently not used
* remote control handling *works* but is broken by design and disabled
since different rc5/rc6/nec remotes return
  different values. Handling can be done using interrupt transfers too (TODO)
* adding support for em2888 based devices (analog TV/digital TV/flash)

recent contributors are CC'ed

Markus
