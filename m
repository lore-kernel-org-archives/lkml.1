Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZI3Kcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZI3Kcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZI3Kcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:32:35 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:52946 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI3Kce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lYvgcNELWUt0shh0sQGHuewJTCMIBP0T3u4J8//NLwm3cShd2DXC6YEbHxtFCh0fhc
         enakegwka5A84aahnbO4WSoOKbmnU3zc1D1tYUXpEsYwbXrkDFaRy9dblOUGoPox/pDS
         mwyIqyLHeZ6vFwFeIX3WM1nH1cNLQR4LjtKZE=
Message-ID: <4AC3325D.3060505@gmail.com>
Date: Wed, 30 Sep 2009 19:26:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Berthold Gunreben <b.gunreben@web.de>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Niel Lambrechts <niel.lambrechts@gmail.com>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it> <200909182226.39660.b.gunreben@web.de> <4ABC42F9.3010403@gmail.com> <200909301158.43972.b.gunreben@web.de>
In-Reply-To: <200909301158.43972.b.gunreben@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Berthold Gunreben wrote:
> It could still be the power supply of course, but I don't understand
> why a new kernel would trigger power outages so often (current
> kernels triggered the problem latest after 5 minutes).

Probably because older kernels didn't handle barrier properly for
raid.  Changing fs can definitely affect things but if I were you I
wouldn't be trusting any valuable data on that configuration.

-- 
tejun
