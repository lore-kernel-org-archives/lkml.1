Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZCMJHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZCMJHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZCMJHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:07:06 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:36012
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251AbZCMJHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:07:04 -0400
X-BigFish: VPS-32(z6cekz1432R98dR1805M936fK9371Pzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGFTBF-02-ECP-01
Date: Fri, 13 Mar 2009 10:06:50 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090313090650.GL20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com> <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com> <20090312114121.GF20716@alberich.amd.com> <86802c440903121124o10439dcdvf8b9fa0b37c62062@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86802c440903121124o10439dcdvf8b9fa0b37c62062@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Mar 2009 09:06:52.0187 (UTC) FILETIME=[0C91E6B0:01C9A3BB]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:24:12AM -0700, Yinghai Lu wrote:
> On Thu, Mar 12, 2009 at 4:41 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> > On Thu, Mar 12, 2009 at 01:01:26AM -0700, Yinghai Lu wrote:
> >> wonder if you could add one dmi check to tell the user that bios is
> >> buggy, ask vendor fixed BIOS
> >> and skip fixed mtrr sync.
> >
> > There seem to be several systems affected that do not hide
> > RdMem/WrMem bits from OS.
> >
> >  (Causing Suspend/resume problem:)
> > - Acer Ferrari 1000
> > - Acer Ferrari 5000
> >  (Causing kernel freeze:)
> > - Asus M51TR-AP003C notebook
> > - Asus M51Ta notebook
> > - Asus M3A-H/HDMI mobo
> 
> they didn't run bios testsuite or bios testsuite miss that checking?

Don't know. I'll try to figure that out.

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


