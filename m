Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbXIZPKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbXIZPKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbXIZPKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:10:36 -0400
Received: from styx.suse.cz ([82.119.242.94]:57647 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753905AbXIZPKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:10:35 -0400
Date: Wed, 26 Sep 2007 17:10:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - drivers/hid/hid-debug.c  - trivial - add KERN_DEBUG
 prefix, fix typo, constify
In-Reply-To: <1190771098.17052.12.camel@localhost>
Message-ID: <Pine.LNX.4.64.0709261708080.7567@jikos.suse.cz>
References: <1190771098.17052.12.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007, Joe Perches wrote:

> Also, exported symbol hid_resolv_event is unused by the current kernel 
> tree and perhaps should be removed.

This is not true, hid_resolv_event() is called from the code that 
establishes the mapping between HID and input, see 
hidinput_configure_usage().

Anyway, I applied your cleanup patch, thanks.

-- 
Jiri Kosina
SUSE Labs
