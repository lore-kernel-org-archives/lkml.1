Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXBZJuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXBZJuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXBZJuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:50:07 -0500
Received: from mx1.suse.de ([195.135.220.2]:34424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXBZJuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:50:05 -0500
Message-ID: <45E2AD54.7020709@suse.de>
Date: Mon, 26 Feb 2007 10:50:12 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [ANNOUNCE] kvm-15 release
References: <45E16E54.60503@qumranet.com>
In-Reply-To: <45E16E54.60503@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> - new userspace interface (work in progress)

kvmfs in kvm-15 kernel code does not to build with older kernels (2.6.16
fails, 2.6.18 works ok), looks like the reason are some changes in
superblock handling.

Do you intend to fix that?

cheers,
  Gerd

-- 
Gerd Hoffmann <kraxel@suse.de>
