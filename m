Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYGHNnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYGHNnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYGHNm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:42:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:54206 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYGHNm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PVU+H3yBgvmOZazKReb9c1uoNP6iF2vB3iwvlY8BcutVCSepw6yA/U5dE0JjUgEddq
         ld5Co8sh2q2hKUQcpYZm9izhBujjAOmWlvL4A5oVc1jQ/sNUcEO2lICcXpTyzHjs7rLP
         3oiDbg5lRma28caH2qt5PGyubtZ/iFn+gsAOI=
Date: Tue, 8 Jul 2008 17:42:42 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: [PATCH 0/3] Genclk: generic framework for clocks managing [v3.1]
Message-ID: <20080708134242.GA6176@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is again a set of patches to unify the management of clocks and
allow easy registration and unregistration of them. This is neccessary
to cleanly support such devices as toshiba mobile companion chips,
sa1111 companion, ASIC3 companion, etc. Also it brings code unification,
especially for a lot of arm sub-arches which share nearly the same code.

Changes from the previous patchset:
* Change the name as requested by Ben: clocklib -> generic clk (genclk)
* Move from lib/clocklib.c to kernel/genclk/*
* Fix locking in generic code

* Rebase PXA patch to the current Russell's tree.
* Interlock access to CKEN registers on PXA.

-- 
With best wishes
Dmitry

