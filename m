Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbZGOEQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbZGOEQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZGOEQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:16:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:57898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZGOEQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:16:57 -0400
Message-ID: <4A5D5830.6000206@kernel.org>
Date: Wed, 15 Jul 2009 13:16:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/9] devres: WARN() and return, don't crash on device_del()
 of uninitialized device
References: <20090712223717.GB16600@kroah.com> <1247438766-17266-1-git-send-email-gregkh@suse.de>
In-Reply-To: <1247438766-17266-1-git-send-email-gregkh@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Jul 2009 04:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> I just debugged an obscure crash caused by a device_del() of a all NULL'd
> out struct device (in usb-serial) and found that a patch like this one would
> have saved me time (in addition to improved chances of a bug report from
> users hitting similar driver bugs).
> 
> [akpm@linux-foundation.org: cleanup]
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
