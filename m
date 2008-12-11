Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYLKAt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYLKAt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLKAts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:49:48 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4550 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYLKAtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:49:47 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: bnx2: fs_sync_timeout, reset code = 1020002
From: "Michael Chan" <mchan@broadcom.com>
To: "Pavel Machek" <pavel@suse.cz>
cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Benjamin Li" <benli@broadcom.com>
In-Reply-To: <20081210075624.GC20166@elf.ucw.cz>
References: <20081204105550.GA2429@elf.ucw.cz>
 <1228411378.9156.52.camel@HP1>
 <20081208145442.GA23820@atrey.karlin.mff.cuni.cz>
 <1228756345.11235.2.camel@HP1> <20081210075624.GC20166@elf.ucw.cz>
Date: Wed, 10 Dec 2008 16:46:35 -0800
Message-ID: <1228956395.9582.50.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 655EBC2F61S21327864-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-09 at 23:56 -0800, Pavel Machek wrote:
> On Mon 2008-12-08 09:12:25, Michael Chan wrote:
> > 
> > Please provide ethtool -i eth0
> > 
> > and lspci -xxx on the Broadcom device.
> 
> Attached. It actually has eth0 & eth1, both seem to be same broadcom...
> 

It looks like the chip is bad or the firmware is bad.  The PCI revision
ID and the serial number are all zeros.  Perhaps we can try to reprogram
the NVRAM or do further diagnostics tests.  I'll have someone contact
you.  Thanks.


