Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYJWSjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYJWSjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYJWSjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJWSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:39:07 -0400
Message-ID: <4900C462.8010208@zytor.com>
Date: Thu, 23 Oct 2008 11:37:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: show dma_mask bits in /sys
References: <20081009211837.GC18444@colo.lackof.org> <48EE7745.2020603@kernel.org> <20081009213551.GC25780@parisc-linux.org> <86802c440810091451y4a3caceg1abaa75464c40a72@mail.gmail.com> <20081009225533.GB1914@colo.lackof.org> <48EE8E55.4000009@kernel.org> <20081012071157.GA20056@colo.lackof.org> <48FFD726.2010600@kernel.org> <20081023032833.GK26094@parisc-linux.org> <20081023064412.GD31186@colo.lackof.org> <20081023153923.GB4011@kroah.com>
In-Reply-To: <20081023153923.GB4011@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Oct 23, 2008 at 12:44:12AM -0600, Grant Grundler wrote:
>> Lastly, /sys seems to have over run even /proc. On an rx2600 (ia64):
>> grundler@gsyprf3:/usr/src/linux-2.6$ find /sys ! -type d | wc
>>    6288    6296  264893
> 
> Is this causing some kind of problem for your systems?
> 
> /sys shows far more information than /proc does, so of course it would
> be larger in quantity.
> 

Furthermore, it is actually structured as individual data items; a lot 
of /proc files are aggregate freeform data.

	-hpa
