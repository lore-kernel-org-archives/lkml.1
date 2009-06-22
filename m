Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZFVHQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZFVHQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZFVHQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:16:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40504 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZFVHQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:16:10 -0400
Message-ID: <4A3F2FB6.6040901@jp.fujitsu.com>
Date: Mon, 22 Jun 2009 16:16:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jay Lan <jay.zen.lan@gmail.com>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org,
       Vivek Goyal <vgoyal@redhat.com>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 0/7] Patches for kdump vs. INIT
References: <4A39E247.4030908@jp.fujitsu.com> <5AA89A0287224699B8E5C0526CE0EA41@Lanx8664>
In-Reply-To: <5AA89A0287224699B8E5C0526CE0EA41@Lanx8664>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Lan wrote:
> Kdump with INIT on IPF worked on SGI's IA64 servers when i left SGI last
> December.
> Is this problem something new to you after .27?

No.
This is a potential bug in design, in case of INIT+INIT and panic+INIT. 

> SGI folks should test this patchset to ensure no surprise is introduced
> to their servers.

Any tests and comments would be appreciated.


Thanks,
H.Seto
