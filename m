Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbZCXUD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbZCXUD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbZCXUDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:03:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39033 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214AbZCXUDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:03:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Lutomirski <amluto@gmail.com>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu) enabled
Date: Tue, 24 Mar 2009 21:03:00 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, x86@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
In-Reply-To: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903242103.01109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added some CCs.

On Tuesday 24 March 2009, Andrew Lutomirski wrote:
> On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system is
> completely hosed on resume.  It appears that even hard disk IO didn't
> work (trying to do *anything* including getting a dmesg trace just
> spewed sda io errors to the console).  Hence no trace.  I did an
> alt-sysrq-b and the screen went blank and the machine just started
> beeping at me.
> 
> Resume works much better with intel_iommu=off.  (I remember seeing a
> patch go by that purported to fix resume with IOMMU enabled, but it
> didn't work for me.)
> 
> I'd be happy to try to make a better bug report if anyone has any bright ideas.
> 
> --Andy
