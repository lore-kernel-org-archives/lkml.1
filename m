Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXKNNII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXKNNII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXKNNH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:07:57 -0500
Received: from styx.suse.cz ([82.119.242.94]:57336 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbXKNNH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:07:56 -0500
Date: Wed, 14 Nov 2007 14:07:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: fix a potential bug in pointer casting
In-Reply-To: <473AAF26.1030407@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0711141407390.12807@jikos.suse.cz>
References: <473AAF26.1030407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Li Zefan wrote:

> Don't directly cast list_head * to foo *, this works only when list is 
> the first member of struct foo, and we should not make the assumption 
> how members are ordered in the structure.

Hi,

applied to my tree, thanks!

-- 
Jiri Kosina
SUSE Labs
