Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZBCJej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZBCJej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZBCJeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:34:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZBCJea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:34:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [BUG] Suspend tries to suspend devices already in D3
Date: Tue, 3 Feb 2009 10:34:11 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200902030949.42342.elendil@planet.nl>
In-Reply-To: <200902030949.42342.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031034.12175.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009, Frans Pop wrote:
> This is the second time I've hit this warning on an STR. Most times
> I do *not* get the warning. The first line is an extra debug printk I added
> after the first occurrence to give me the driver causing the problem.
> 
> What is different is that before this suspend I had switched to my wired
> e1000e NIC and had done an ifdown on the wireless. I suspect that because
> of that the wireless already was at D3 _before_ the suspend was started.

If ifdown causes the device to go into D3, then this is possible.

> Could this be the same issue as reported by Ming Lei?

Yes, it could.

Thanks,
Rafael
