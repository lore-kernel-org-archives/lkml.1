Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbYF2FwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbYF2FwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYF2FwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:52:14 -0400
Received: from ag-out-0708.google.com ([72.14.246.249]:9961 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYF2FwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=h1oX0SKhMroENbhYupeCcoGnY8nH74Jx8d+FJEFD9bRuj2ToQTV9oA57hk7UATRsa+
         RnttSQnyt4qlcWxI64b4TtC+6Y9RDq9ZXd2+nwvhYcc8TOM+pRp99atp4EaUt+0Z1+PC
         Q1VsUT1jELs/Hm7cFCptAIVcdqsYOi6AGig7M=
Message-ID: <c058f1520806282252o789ea328kc7cb061a1d29478@mail.gmail.com>
Date: Sat, 28 Jun 2008 22:52:10 -0700
From: "X Jin" <jinx080808@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Supporting both PCM and HDMI audio
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a video/audio capture card with both PCM analog audio and HDMI
inputs. I've done some homework on the ALSA framework and have some
idea how to capture the analog audio. Basically it's to define a
capture substream in PCM interface. However I'm a little lost on how
to capture HDMI audio under ALSA.

The sound/pci/hda directory has the support of Intel high definition
audio codec. I think this is nothing to do with HDMI audio. Right?

>From some old conversations regarding to similar issues in this
mailing list such as this (http://lkml.org/lkml/2008/5/22/170), my
impression is that HDMI audio is just a different format (typically
SNDRV_PCM_FORMAT_S16). It's still the PCM interface that captures the
audio. Is my understanding right?

I really need some direction/advice on this.

TIA.
-XJ.
