Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbXH1PCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbXH1PCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXH1PCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:02:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40405 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXH1PCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:02:08 -0400
Date: Tue, 28 Aug 2007 20:45:07 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Paul Albrecht <albrecht@rdi1.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: dm-crypt mount returns EINVAL
In-Reply-To: <1188307465.2653.12.camel@albrecht.rdi1.com>
Message-ID: <alpine.LFD.0.999.0708282042210.24588@enigma.security.iitk.ac.in>
References: <1188307465.2653.12.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,


On Tue, 28 Aug 2007, Paul Albrecht wrote:

> Hi,
> 
> I have recently upgraded my kernel to 2.6.21 from 2.6.20 and that has
> caused a problem mounting an encrypted partition using dm-crypt.
> 
> In my init script, I use cryptsetup to create device which I use to
> mount an encrypted partition. Since I changed to 2.6.21 the mount fails
> returning an EINVAL status which doesn't make much sense because the
> init script is unchanged and works if reverted to 2.6.20.
> 
> Any ideas? How can I debug this problem? I'm not subscribed to lkml so
> please cc in your response.

What was the error you got from cryptsetup()? Also, please post the
kernel's dmesg log and the .config of the 2.6.21 kernel (new one).

Also, compare the .config's of the two kernels and ensure that
CONFIG_DM_CRYPT (or possibly one of the _CRYPTO_ config options)
didn't get lost or automatically unset during the upgrade/oldconfig.


Satyam
