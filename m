Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYGFGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYGFGtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 02:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYGFGtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 02:49:08 -0400
Received: from science.horizon.com ([192.35.100.1]:17248 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751436AbYGFGtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 02:49:07 -0400
Message-ID: <20080706064904.10507.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 06 Jul 2008 02:49:04 -0400
To: linux@horizon.com, dan.j.williams@intel.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc8 deadlock: RAID code?
References: <20080704125551.24267.qmail@science.horizon.com>
 <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
In-Reply-To: <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Williams" <dan.j.williams@intel.com> wrote:
> Are you running with CONFIG_NUMA=n?  If so, you may be seeing the
> effects of kswapd not running. See the patch at:
>
>      http://marc.info/?l=linux-mm&m=121510360428340&w=2

Indeed I am.  My apologies for not including the kernel config.
That's in -rc9, so I've rebased to that and we'll see what happens.

Thank you so much!
