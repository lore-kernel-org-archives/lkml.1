Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbZINSQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbZINSQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932655AbZINSP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:15:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:32920 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbZINSP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=aXo9WexK9LG9t1CktL5qFszy1i0LFceP+X2VXup/n9dsT4V4VGQPpqel3dMx7hbvhJ
         mczvCd9Cri+aDjNNxf9mUhbI+DrftWLIybK9BxTtFm8o4GSgyaxQKEUtvTKjo0Y3zCFG
         O4rLtfCdlAOb5YsVEl4LJ8WUalbEHoF1RjNEs=
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Date: Mon, 14 Sep 2009 20:15:56 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909142015.56698.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
found the problem. Was stupid brain fart when doing menuconfig or something 
like that.

I turned off 
USB selective suspend/resume and wakeup 

and turned on
Root Hub Transaction Translators 
 Improved Transaction Translator scheduling

and haven't had any lockup anymore.

Sorry for the noise. Really.

Glück Auf,
Volker
