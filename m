Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZFBWZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZFBWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZFBWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:25:15 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:59996 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZFBWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=uZ+5Pj42ylqx6vu06ATaKjtxO/FY9it0E+KeBupU51lYHyYz81GeFw+KEAAmmW1Cld
         p/8hrvr1ihZ6CVm8Vdd0rz7b8x9w+gEtpCGS/GV8L3nTtXUtZTjTozA8Tz7U/sGDozcb
         pz1UQsb0TbGNozpxI9CrDD20boR3hT3RFTkks=
MIME-Version: 1.0
Date: Wed, 3 Jun 2009 00:25:14 +0200
Message-ID: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
Subject: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I gave today kernel 2.6.30rc7 a spin on my Athlon 64 system and it
seems there's yet again a problem with libata limiting IDE disks to
UDMA33 since it thinks that the cable is only 40 wires. My distro
kernel which is 2.6.27.21 does not have this problem and correctly
sets my disks to UDMA133. I googled around and it seems in the past
this was a known problem for some kernels. Any suggestions? :)

Please cc me as I'm not subscribed to the list
