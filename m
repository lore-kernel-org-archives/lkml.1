Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbYJVMx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbYJVMx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYJVMxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:53:49 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:40476
	"EHLO luto.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbYJVMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:53:48 -0400
Message-ID: <48FF2259.1010800@myrealbox.com>
Date: Wed, 22 Oct 2008 08:53:45 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Issue with e1000
References: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
In-Reply-To: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras wrote:
> Hi,
> 
> I've been trying 2.6.27 and 2.6.27.2, and I haven't been able to use
> the e1000 module.
> 
> I let my system handle the networking, Network Manager in Fedora 9,
> but I also tried this:
> ifup eth0
> Device eth0 does not seem to be present, delaying initialization.
> 
> The module is not loaded automatically so I'm loading it myself,
> nothing happens.
> 
> I'm also trying this:
> modprobe e1000 debug=16
> 
> I see nothing special:
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> 
> Am I missing something?

Depending which hardware you have, you may need to use e1000e instead.

http://lwn.net/Articles/278016/

--Andy
