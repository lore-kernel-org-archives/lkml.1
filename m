Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZEMGlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZEMGlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZEMGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:41:00 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:32971 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZEMGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:40:59 -0400
X-Auth-Info: OrhV+NM/hLF1F8/3QqbsPMh40OnjbpwWvuDjtwacvm4=
Message-ID: <4A0A683B.5010209@denx.de>
Date: Wed, 13 May 2009 08:27:07 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX GmbH
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Wolfgang Denk <wd@denx.de>
CC: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash,
 size
References: <mailman.7754.1242158509.26545.linuxppc-dev@ozlabs.org>
In-Reply-To: <mailman.7754.1242158509.26545.linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfgang,

> The current device tree for the MPC8272ADS assumes a mapping of 32 MB
> of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
> the boards, mapped at 0xFF80.0000. When booting an uImage with such a
> device tree, the kernel crashes because 0xFE00.0000 is not mapped.

Wouldn;t it be better, if u-boot fixes the device tree entries?
I think, u-boot should know, where the flash begins and ends, and
because this is maybe a dynamic variable for this board, it should
be better, if u-boot fixes this, so no need for adding a device tree
for every board variant.

bye
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
