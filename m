Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYEPM7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYEPM7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYEPM7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:59:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:31941 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYEPM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PHV7qDqaQMfHNjQrfuFvnrX5ziiPjddtgyYSaEWz0//VXonzbOLhOriMlcNDNhOl6Knb65x0Tf4xRv5V6washuQUqjmtXHXmHxMN86SVO+BCwOoQsTLtCO8AaCMymj0dWapVsCdGm/qN9l7tV/kuhuPjE+Dc+Hgv60O3zLBjB5Q=
Message-ID: <6101e8c40805160559i4eb94ba7y7cbfea9c3f528821@mail.gmail.com>
Date: Fri, 16 May 2008 14:59:21 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Bad value with w83627thf
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-2.6 - git HEAD on: 9662369
lm-sensors: 1:3.0.1-5
libsensors4: 1:3.0.1-5
os: debian lenny
sernsor: w83627thf on asus p4c800 MB

with 2.6.26-rcX kernel, reported false Battery values,
-------------------------------------->
VBat:        +3.26 V  (min =  +0.02 V, max =  +3.01 V)   ALARM
<-------------------------------------
lspci -xxx
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
Controller (rev 02)
00: 86 80 d3 24 01 00 80 02 02 00 05 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 04 00 00 00 00 00 00 00 00 00 00 43 10 a6 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 03 02 00 00
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 66 0f 04 00 00 00 00 00

-- 
Thanks,
Oliver
