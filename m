Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXCEEeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXCEEeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXCEEeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:34:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:23186 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbXCEEeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:34:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PzfvQ85ldBgUe4nGo9oOoqIqdLoFlZO9pVbUbJfo/gKG5sW7Ij+1UyYActmiZvg8KheOufI/tsi/n2HvBEHW4fAbS02NBwkKt6ywGKvr98hs1w9OIM29EFNaO6gxvTOUl5GFscF/3XiaCsBlxahfFbWCcv27Ej+YaU0MAP12hgs=
Message-ID: <75b66ecd0703042034l4e50c88fueb31cfa508cf672f@mail.gmail.com>
Date: Sun, 4 Mar 2007 23:34:29 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Patrick Ale" <patrick.ale@gmail.com>
Subject: Re: [IPW3945] Can't load microcode
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <8d158e1f0703040841m634b37d4r9f2d4135f5f4dfd6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0703040841m634b37d4r9f2d4135f5f4dfd6@mail.gmail.com>
X-Google-Sender-Auth: e36be579b32acc37
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> ieee80211_crypt: registered algorithm 'NULL'
> ieee80211: 802.11 data/management/control stack, git-1.1.13
> ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.0d
> ipw3945: Copyright(c) 2003-2006 Intel Corporation
> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 18 (level, low) -> IRQ 22
> PCI: Setting latency timer of device 0000:05:00.0 to 64
> ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> ipw3945: ipw3945.ucode load failed: Reason -2
> ipw3945: Could not read microcode: -2
> ipw3945: probe of 0000:05:00.0 failed with error -2

Error -2 is "No such file or directory".  Maybe it expects the
firmware to be somewhere other than /lib/firmware or your driver and
firmware versions don't match.  Try adding some debug printk()s around
the request_firmware() call in the driver.

If you're using out of tree drivers the error should be reported to
Intel rather than this list.

Lee
