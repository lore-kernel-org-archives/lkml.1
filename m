Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZLWJtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZLWJtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 04:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZLWJtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 04:49:39 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:47308 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbZLWJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 04:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MKTJkOwp/oGOEYNbD1/9GGCjN/Ur2i58dxTBlvEk+awQbWjWrHtDvDwiS6KL8RIDDq
         165Rx8I30mMXCPKdY+Kbpsp+9ovAcwkt+ScSsCa4mSg+TiMbSaRUaHf7ykA8owk1pSQR
         +p3GDBn+a+m1bCSuLyX36PLspuf56cGLXcA3E=
MIME-Version: 1.0
Date: Wed, 23 Dec 2009 15:19:37 +0530
Message-ID: <ba5648fa0912230149o3401332cxb986a1e4aa675a0b@mail.gmail.com>
Subject: service search for headset
From: bluezprofile kernel <bluezprofile@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am trying to get the service of the remote device. I have used
sdptool browse <remote mac>
to get the list of services supported by the remote device.

I have done between two laptops and I am able to see the services available.
When I do the same for my hands free device, I am not able to get the
service details of handsfree unit.
I have debugged this using sdptool application source.
sdptool application sends the attribute request to the hands free
device, in the reply I am not getting anything.

sdptool record <remote mac> works fine.
sdptool browse --l2cap <remote mac> also works fine
Why --l2cap option required. Please any one explain me.

In my blueman application it shows the list of services when I pair.
Are they using record mechanism to display services?
Any one please help me in this regard.

I have used bluez 5.58
Nic Shen
