Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYJNLFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYJNLFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYJNLFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:05:44 -0400
Received: from moog.chdir.org ([88.191.42.160]:35593 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbYJNLFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:05:43 -0400
Date: Tue, 14 Oct 2008 13:05:39 +0200
From: Nicolas Bareil <nico@chdir.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nico@chdir.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Message-ID: <20081014110539.GA2997@sd-5945.dedibox.fr>
References: <20081014072045.GA1252@sd-5945.dedibox.fr> <200810141148.48220.oliver@neukum.org> <20081014104500.GB1252@sd-5945.dedibox.fr> <20081014200016H.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014200016H.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 08:00:09PM +0900, FUJITA Tomonori wrote:
> > > Is this a regression? Did it work on earlier kernels?
> > 
> > Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.
> 
> With old kernels, you can find something like the following line in
> the boot log?
> 
> PCI-DMA: Using software bounce buffering for IO (SWIOTLB)

Indeed, I have this line:

Oct 14 12:46:29 brew kernel: [    0.004000] Calgary: detecting Calgary via BIOS EBDA area
Oct 14 12:46:29 brew kernel: [    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Oct 14 12:46:29 brew kernel: [    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Oct 14 12:46:29 brew kernel: [    0.004000] Placing software IO TLB between 0x4000000 - 0x8000000
Oct 14 12:46:29 brew kernel: [    0.004000] Memory: 4055544k/4980736k available (2225k kernel code, 138092k reserved, 1079k data, 392k init)
Oct 14 12:46:29 brew kernel: [    0.004000] CPA: page pool initialized 1 of 1 pages preallocated

The full kern.log is available here: http://chdir.org/~nbareil/kern.log-2.6.26-1

Thanks!

