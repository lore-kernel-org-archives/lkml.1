Return-Path: <linux-kernel-owner+w=401wt.eu-S1763682AbXLTWss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763682AbXLTWss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXLTWsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:48:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59814 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXLTWsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:48:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Peer Chen" <pchen@nvidia.com>
Cc: "peerchen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Andy Currid" <ACurrid@nvidia.com>
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
References: <200712182300373901202@gmail.com>
	<m14pefaclv.fsf@ebiederm.dsl.xmission.com>
	<15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com>
Date: Thu, 20 Dec 2007 15:48:08 -0700
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B1F24C119@hkemmail01.nvidia.com>
	(Peer Chen's message of "Thu, 20 Dec 2007 21:43:00 +0800")
Message-ID: <m1d4t17zkn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Peer Chen" <pchen@nvidia.com> writes:

> The quirk is for our Intel platform, we don't want HT MSI mapping
> enabled in any of our devices.

Why is this a problem?  I seem to recall a real hypertransport bus
downstream of the Intel cpu.

If there is a real hypertransport bus in the middle then what happens
if someone puts a tunnel that uses hypertransport between the two chips?

I feel very dense right now.  I don't understand why enabling the
mapping on an Intel based system is a problem.  I am afraid there is
some important gap in my understanding in which case we may need to
rethink enabling the hypertransport capability by default.

If disabling the hypertransport bus is simply an optimization, or it
is to deal with an issue that appears exclusive to Nvidia chips
I have no problem with your quirk.

Eric
