Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYIYUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYIYUGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIYUGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:06:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50336
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbYIYUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:06:32 -0400
Date: Thu, 25 Sep 2008 13:06:19 -0700 (PDT)
Message-Id: <20080925.130619.193699562.davem@davemloft.net>
To: jkosina@suse.cz
Cc: elendil@planet.nl, airlied@gmail.com, jeff@garzik.org,
       akpm@linux-foundation.org, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com, mingo@elte.hu,
       jbarnes@virtuousgeek.org, jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
References: <alpine.LNX.1.10.0809250310190.4671@pegasus.suse.cz>
	<200809250401.54818.elendil@planet.nl>
	<Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 25 Sep 2008 19:24:57 +0200 (CEST)

> If being set to 0 (it's so easy to call memset(0) on a bogus pointer, 
> there are usually lots of them in the code) or to random garbage, it would 
> seem to be much more understandable, than 0xff.

Setting framebuffer bytes to 0xff is pretty common, for example
for color keys and anti-aliasing pixel values.
