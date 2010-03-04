Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0CDRH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:07:59 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:12089 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab0CDRH5 (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Thu, 4 Mar 2010 12:07:57 -0500
Message-Id: <4B90839902000023000142EB@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Mar 2010 10:07:53 -0700
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <mzxreary@0pointer.de>, <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that
	 is need load SCM
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

於 三，2010-03-03 於 13:45 +0000，Matthew Garrett 提到：
> On Tue, Mar 02, 2010 at 09:52:12PM -0700, Joey Lee wrote:
> 
> > I developed this driver on 2.6.31 kernel, and I found this key code is
> > in 2.6.33 kernel and later.
> > There have one and only one scancode to control 3 devices when end user
> > press fn+f11 key on MSI N034.
> > Currently, we setup this mapping in HAL key and mapping it to KEY_WLAN.
> 
> Ah! The key comes through the keyboard controller? In that case, yeah, 
> just map it to KEY_RFKILL in hal isntead of KEY_WLAN. Everything should 
> work fine then. If rfkill-input is configured, it'll kill all the 
> radios. If userland claims it instead, it can cycle through with 
> whatever policy is desired.
> 

Thank's for your review and suggestion.
Per discuss for msi-laptop patchset, I will submit a bit patch for the
following change:
	- remove threeg sysfs interface.
	- add KEY_RFKILL keymapping to msi-laptop.

Does it make sense? or I still miss something important?


Thank's
Joey Lee

