Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbYCEAwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbYCEAwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935427AbYCEAtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:49:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:33365 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934886AbYCEAtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:49:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 5 Mar 2008 01:48:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: reread config ROM when device reset the
 bus
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
In-Reply-To: <tkrat.5eee3ebd5076fd4a@s5r6.in-berlin.de>
Message-ID: <tkrat.55f8e340ac08be4c@s5r6.in-berlin.de>
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de> 
 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>
 <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
 <tkrat.5eee3ebd5076fd4a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - moved from dev->dem to idr_rwsem
>   - extended note about semaphore protection of .config_rom and
>     .config_rom_length
>   - secure a few more places which access the config_rom...
>     should have covered all of them now

Hmm.  When I power the PC down there are lots of messages scrolling by
which look somewhat like lockdep spew.  I can't reproduce this merely by
module unloading though.  So don't put this patch into production yet.
-- 
Stefan Richter
-=====-==--- --== --=-=
http://arcgraph.de/sr/

