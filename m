Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYJUGMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYJUGMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYJUGLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:11:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46218 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYJUGLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:11:37 -0400
Message-ID: <48FD7292.5020401@garzik.org>
Date: Tue, 21 Oct 2008 02:11:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, brice@myri.com,
       dan.j.williams@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, tiwai@suse.de, apw@shadowen.org,
       linuxppc-dev@ozlabs.org, sam@ravnborg.org,
       e1000-devel@lists.sourceforge.net, maciej.sosnowski@intel.com,
       bunk@kernel.org
Subject: Re: [PATCH] igb: add IGB_DCA instead of selecting INTEL_IOATDMA
References: <20081017180831.15639.50705.stgit@gitlost.lost>
In-Reply-To: <20081017180831.15639.50705.stgit@gitlost.lost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher wrote:
> Add a bool IGB_DCA defined to y if IGB and DCA are enabled, but IGB isn't y while DCA=m.  And thus remove the need to select INTEL_IOATDMA when IGB is enabled, so that non-x86 architectures can build the igb driver.
> Based on work/patch from Brice Goglin <brice@myri.com>
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

applied


