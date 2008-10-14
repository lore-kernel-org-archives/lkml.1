Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYJNImx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYJNImx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYJNImo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:42:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:24968 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbYJNImm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aqaOUWBK2DK59/CH5b+LGrkOK52NUbT7l5kvooj9dO+kcyBde575AZzHUwIJ1l4L9m
         LegtzesigmPGCSQ73Vx6BG1QNv48sM2B/1XJIfwQAFeBqgJhL9ZLwQzHfC2YJTDFh7Qa
         JcYSm4VEA2JAPIX7aY5+diXaklIafOzSHZ9Co=
Message-ID: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:42:42 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: [BUG] hang with ath5k
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.27 + ath5k, while using wpa_supplicant & wpa_gui system hangs
occasionally, keyboard not respond, network stop working.

There's same problem in before kernel version, but I don't know the
first version which introduce it.

The last messege on xconsole is:

disassosiating by local choice

I reproduced it by:

1) run wpa_supplicant
2) ctrl + C
3) goto 1)

-- 
Regards
dave
