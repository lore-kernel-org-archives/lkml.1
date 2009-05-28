Return-Path: <linux-kernel-owner+w=401wt.eu-S1764320AbZE1Umy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764320AbZE1Umy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764354AbZE1Umm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:42:42 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:62428 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764175AbZE1Uml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=AtxcP28gri1frnOldgAZPM2BdS5WatrdLDAAq2oJ6KE6lv203BzOQnYMi49CBXFTWN
         wZgZ3Wsi0GXbmRqTZqYEd+J6R5cfmUCr8sqLd/gxDM2XsJvX2hHajwv1i/Iv/TntYkWt
         vRTej4teG/tGz+t4AA4sfqday6JtS6BCJYPqw=
MIME-Version: 1.0
Date: Thu, 28 May 2009 22:42:38 +0200
Message-ID: <620d582f0905281342l6e275547ud6d5cf84614eeb7a@mail.gmail.com>
Subject: HTB class parameter change in lkm
From: Piotrek D <regis44@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to change the rate parameter of HTB class by using this
code from within one of my functions :

  struct htb_class *cl;
  cl=htb_find(number,q);

  cl->rate->rate.rate = NEW_RATE_VALUE;

 TC shows the correct values, but the traffic rate doesn't change a bit.
 Does anyboyd have any idea what am I doing wrong ? Maybe there would
be a faster way by sending a netlink  message ?

Piotrek
