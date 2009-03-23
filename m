Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZCWSQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZCWSQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbZCWSPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:15:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760216AbZCWSPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:15:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [linux-pm] [RFC][PATCH 1/2] PCI PM: Introduce __pci_set_power_state()
Date: Mon, 23 Mar 2009 19:14:58 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903210003.55161.rjw@sisk.pl> <200903222211.50930.rjw@sisk.pl> <1237763285.11186.2.camel@nigel-laptop>
In-Reply-To: <1237763285.11186.2.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231914.59762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009, Nigel Cunningham wrote:
> Hi.

Hi,

> It's not an error if we fail to set the desired state? (I see you have a
> dev_warn only).

Theoretically, it is, but since we've never returned errors in such cases,
we'd probably see some unexpected suspend failures if we started to do that
now.

Thanks,
Rafael
