Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbYJPTTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbYJPTTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYJPTT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:19:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYJPTT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:19:26 -0400
Date: Thu, 16 Oct 2008 12:18:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: BARRE Sebastien <sbarre@sdelcc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26.5] rtc-ds1307 : SMBus compatibility
Message-Id: <20081016121843.2e0c3792.akpm@linux-foundation.org>
In-Reply-To: <C1C62166118DFA4A8BBA01A2411F0D170E9BE59C2F@PRI-MBX-101.dom1.vinci-energies.net>
References: <C1C62166118DFA4A8BBA01A2411F0D170E9BE59C2F@PRI-MBX-101.dom1.vinci-energies.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008 14:55:52 +0200
BARRE Sebastien <sbarre@sdelcc.com> wrote:

> This patch change all i2c access functions to SMBus access functions in order to use the ds1307 on SMBus.
> I expect that using SMBus access functions is correct for all boards with i2C or SMBus adapter. Is it correct ?
> 
> I have tested it on my Geode LX board with a ds1307 device.
> 

Alas, some patches against that driver have just been sent to Linus and
this patch isn't mergeable any more.  Can you please redo it against
2.6.28-rc1 (when that is released) or Linus's current git tree and
resend, copying the following:

i2c@lm-sensors.org
David Brownell <david-b@pacbell.net>
Alessandro Zummo <a.zummo@towertech.it>
linux-kernel@vger.kernel.org
Andrew Morton <akpm@linux-foundation.org>

Also, your email client replaced all the tabs with spaces.  Please fix
that up beforehand.

Thanks.

