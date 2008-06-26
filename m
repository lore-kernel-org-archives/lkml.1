Return-Path: <linux-kernel-owner+w=401wt.eu-S1764763AbYFZNHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764763AbYFZNHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbYFZMut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:50:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:64154 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761490AbYFZMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dvP2PfhiQX07CwE7DFyw0Zs+8U+RUx3DB1KypjgVkKqWz+aZer3eEnkYC9tkU4uNHY
         uIWzLGvVts1E3ZfbCkKw4GrWuv7KxxFK6/2eUXquOIeK3jS1YZGcKB6jIOj9EU0exwJ5
         0yXND2Fls1my+kxHt/DEr8cLuHr2zOAeSmaGA=
Date: Thu, 26 Jun 2008 16:50:33 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: [PATCH 0/3] Clocklib: generic framework for clocks managing [v3]
Message-ID: <20080626125033.GA7093@doriath.ww600.siemens.net>
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
sa1111 companion, etc. Also it brings code unification, especially for a
lot of arm sub-arches which share nearly the same code, etc.

This is the "version 3" approach. Given the negative response to
kobjects, I've redesigned it to use plain krefs.

Debugfs support is merged into main clocklib patch. Documentation
for it's interface will come later. For now it provides tree structure
with single file per each clock directory.

-- 
With best wishes
Dmitry

