Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYIDUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYIDUQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYIDUQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:16:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46926 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYIDUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:16:12 -0400
Date: Thu, 4 Sep 2008 22:19:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904201926.GN18288@one.firstfloor.org>
References: <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 08:01:31PM +0000, Mingarelli, Thomas wrote:
> Exactly.
> 
> The hpwdt driver is meant to be a catch-all for any NMI coming through on ProLiant HW only. Moreover, for newer ProLiant HW at that.
> 
> Once the NMI comes in, we call into our BIOS for the true reason of the NMI. That message gets logged to the IML in NVRAM for the user to view. We then panic the system.

The BIOS tells you about the NMI reason and tells you if the
watchdog didn't fire? 

If yes that's great. You can be a good NMI citizen then. 
Just check if the NMI came from your watchdog and if not return
NOTIFY_DONE

-Andi

