Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbYJJTSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbYJJTSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbYJJTRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:17:52 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:45154 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856AbYJJTRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:17:51 -0400
Date: Fri, 10 Oct 2008 20:17:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic - unify APIC_DIVISOR
In-Reply-To: <20081010190350.GA25931@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0810102011260.19747@ftp.linux-mips.org>
References: <20081010150017.GD7328@localhost> <7E82351C108FA840AB1866AC776AEC46378236B8@orsmsx505.amr.corp.intel.com> <20081010163101.GG7328@localhost> <7E82351C108FA840AB1866AC776AEC46378238AE@orsmsx505.amr.corp.intel.com> <20081010171645.GI7328@localhost>
 <20081010190350.GA25931@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Venki Pallipadi wrote:

> If there is no pressing reason to change the initial calibration value, how
> about the simple patch below.
> 
> The 10^9 value that is used for 100 mS calibration time is pretty big as
> tglx's comment points out. We will only underflow it if there is a
> bus clock running at 10 GHz * 16 = 160 Ghz.
> 
> This way we will not fix something that is not really broken today and will not
> break in foreseeable future.

 I am fine with this version too.  The initial count value used for 
calibration is really arbitrary -- for all the systems I have seen the 
APIC clock was in the sub-MHz range.  And 64-bit hardware runs both code 
variations so the choice of what the 32-bit code version does is 
appropriate as it is also known to work with 32-bit equipment.

  Maciej
