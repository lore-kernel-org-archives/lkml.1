Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZA0DgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZA0DgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZA0DgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 22:36:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44107 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZA0DgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 22:36:08 -0500
Date: Mon, 26 Jan 2009 19:32:11 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devpts multiple instances feedback
Message-ID: <20090127033211.GA13552@us.ibm.com>
References: <20090103155209.GA17988@lst.de> <20090103161544.GA18976@lst.de> <20090126215321.GA20726@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126215321.GA20726@lst.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
| On Sat, Jan 03, 2009 at 05:15:44PM +0100, Christoph Hellwig wrote:
| > This is a little untested patch to massage the mount code into about
| > how it should look like:
| 
| ping?

I was waiting for discussion on the other thread. But yes, this does
simplify the code by copying in the common code in get_sb_single() and
get_sb_nodev() into devpts, and eliminating the do_remount() stuff in
'single-mount' mode.

We may also be able to define an "empty" mknod_ptmx() when
CONFIG_DEVPTS_MULTIPLE_INSTANCES=n and share a bit more code, but will
defer that to a separate patch.

Will test this out some more and resend the modified patch.

Sukadev
