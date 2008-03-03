Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYCCKgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYCCKgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYCCKgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:36:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:33779 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753972AbYCCKgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:36:02 -0500
Date: Mon, 3 Mar 2008 11:36:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
cc: linux-input@vger.kernel.org, Alexander <pikachu@millennium.udm.ru>,
       bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix build failure in hiddev_ioctl with gcc 3.2
In-Reply-To: <20080302231209.36e2c619@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0803031127530.15209@jikos.suse.cz>
References: <20080302231209.36e2c619@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008, Jean Delvare wrote:

> Fix build failure in hiddev_ioctl with gcc 3.2:
> http://bugzilla.kernel.org/show_bug.cgi?id=10121
> The trick is to move the handling of ioctls which need to allocate
> memory to separate functions.

Hmm, I can't say I like doing these shuffles just because of gcc 3.2 
behvior ... but as there are apparently already other patches in Linus' 
tree which did just that, I will have to follow this precedent.

Thanks,

-- 
Jiri Kosina
SUSE Labs
