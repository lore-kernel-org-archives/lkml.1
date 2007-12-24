Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbXLXLtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbXLXLtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 06:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXLXLth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 06:49:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60370 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXLXLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 06:49:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Peer Chen" <pchen@nvidia.com>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
References: <200712182300373901202@gmail.com>
	<m14pefaclv.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com>
	<m1d4t17zkn.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1F571D0F@hkemmail01.nvidia.com>
Date: Mon, 24 Dec 2007 04:49:01 -0700
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1F571D0F@hkemmail01.nvidia.com>
	(Peer Chen's message of "Mon, 24 Dec 2007 17:10:29 +0800")
Message-ID: <m1lk7kl3de.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peer Chen" <pchen@nvidia.com> writes:

> I feel it's dangerous to set the En bit on Intel platform, If the HT MSI
> En is set, the MSI should be expected to transform to HT INT message
> format. It may cause interrupt lost or hardware internal state machine
> failed depend on the hardware design.

Reasonable.  As long as what the quirk is to avoid errata and
chipset specific issues I don't have a problem with it.

I figure the quirk should be a separate patch though.

My concern is that the general rule that always enabling HT MSI
mapping capabilities is reasonable.  Even if there are some
specific exceptions where we don't want to do that.

I want code that requires the smallest list of chipset
exceptions that we can make. 

Eric
