Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0BSMpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:45:45 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15132 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0BSMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:45:43 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz1432R1453M98dNzz1202hzz3198u327alz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KY3A3Y-02-33U-02
X-M-MSG: 
Date: Fri, 19 Feb 2010 13:45:40 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
Message-ID: <20100219124540.GC30243@aftab>
References: <20100123113359.GA29555@one.firstfloor.org>
 <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org>
 <20100216204732.GA2301@elte.hu>
 <4B7B1C40.8070208@linux.intel.com>
 <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain>
 <20100219121734.GA8300@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100219121734.GA8300@basil.fritz.box>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Feb 2010 12:45:35.0698 (UTC) FILETIME=[6E7B0320:01CAB161]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 01:17:34PM +0100, Andi Kleen wrote:

<snip all the perf analysis>

I think you're missing the point - it doesn't have to be
perf. It could just as well be some other tool which _shares_
functionality with perf. See this last mail from Ingo:
http://marc.info/?l=linux-kernel&m=126635420607236 on which you were
also CCed, by the way, where he suggests that we could have a tool
called 'hw' which reuses functionality with perf but concentrates on
error handling and all that RAS functionality in modern CPUs. It should
also have a daemon component etc...

> > year. You are refusing to work with other people on a well designed

Sorry, but from our last discussion on attempting to work towards such
an infrastructure solution I got the same impression as Thomas and Ingo
that you're simply not willing to work together on getting a real thing
done. That's why I stopped bothering - it simply made no sense to me to
waste time in fruitless discussions.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

