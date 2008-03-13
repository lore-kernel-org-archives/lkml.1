Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYCMNBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYCMNBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYCMNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:01:31 -0400
Received: from rtr.ca ([76.10.145.34]:2604 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbYCMNBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:01:30 -0400
Message-ID: <47D925A7.1030706@rtr.ca>
Date: Thu, 13 Mar 2008 09:01:27 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Fred ." <eldmannen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
In-Reply-To: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Dell X1 notebook had this problem HUGELY, back in about 2.6.18 or so.
Under *no* load to speak of, X would lose track of a "key up" event
and forever be stuck on "key down".

I could still use the mouse to start another X session simultaneously,
and in that alternate X things worked fine.  So it was definitely an
X server process issue, not a system wide kernel thing.

And not a GNOME thing -- I use KDE exclusively.

Problem seems to have gone away since I put 2.6.23 onto that machine.
Newer kernels have broken suspend/resume there, so 2.6.23 is as high
as that one gets for now.

-ml
