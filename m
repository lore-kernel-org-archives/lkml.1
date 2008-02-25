Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbYBYCRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbYBYCRz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYBYCRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:17:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYBYCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:17:47 -0500
Message-ID: <47C2252C.30405@zytor.com>
Date: Sun, 24 Feb 2008 18:17:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] x86 - boot/header.S
References: <20080223082026.GA6747@cvg> <86802c440802230044sbfc909t656aadf5729b31c2@mail.gmail.com> <20080223090739.GB6747@cvg>
In-Reply-To: <20080223090739.GB6747@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Look, we only have head64.c - there is no head32.c at all.

That's true to some degree, but head64.c contains a bunch of stuff which 
lives in setup_32.c in the 32-bit world.

	-hpa
