Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZESRym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZESRym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZESRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:54:35 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:8873 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752484AbZESRyd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:54:33 -0400
X-BigFish: VPS-26(zz1432R98dR148cM1805Mzz1202hzzz32i6bh6di43j)
X-WSS-ID: 0KJWKEI-02-1AZ-01
Date: Tue, 19 May 2009 19:54:26 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: edac-amd tree build failure
Message-ID: <20090519175426.GC18874@aftab>
References: <20090519171839.19702b81.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090519171839.19702b81.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 19 May 2009 17:54:25.0801 (UTC) FILETIME=[D9455790:01C9D8AA]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, May 19, 2009 at 05:18:39PM +1000, Stephen Rothwell wrote:
> Hi Boris,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> usr/include/asm/msr.h:5: included file 'asm-x86/cpumask.h' is not exported
> 
> Caused by commit 32b946f3cb8b1c5563dc9525fda85049ea26d1ad ("x86: add
> methods for writing of an MSR on several CPUs").

thanks for reporting, I've added a fix for the build failure and updated
the #for-next branch for you to pull for the next linux-next release.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

