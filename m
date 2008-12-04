Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYLDR0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYLDR0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbYLDR0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:26:14 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1294 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbYLDR0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:26:14 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: bnx2: fs_sync_timeout, reset code = 1020002
From: "Michael Chan" <mchan@broadcom.com>
To: "Pavel Machek" <pavel@suse.cz>
cc: "kernel list" <linux-kernel@vger.kernel.org>, benli@broadcom.com
In-Reply-To: <20081204105550.GA2429@elf.ucw.cz>
References: <20081204105550.GA2429@elf.ucw.cz>
Date: Thu, 04 Dec 2008 09:22:58 -0800
Message-ID: <1228411378.9156.52.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6526CD2061S19090084-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-12-04 at 02:55 -0800, Pavel Machek wrote:
> Hi!
> 
> I'm getting `subj` (with different numbers, 1020002, 1020004,
> sometimes 102006). ifconfig eth0 up fails, network is completely
> broken.

Which kernel are you using?  If it used to work before 2.6.26 or so, it
may be because of the PCI VPD access going beyond the size limit.  We
should have a PCI quirk to prevent this, but may be it is not complete.

> 
> Devices are 14e4:1639... Any hints/ideas? (It is possible this is
> broken hardware).
> 									Pavel


