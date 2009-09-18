Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZIROxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZIROxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZIROxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:53:42 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:43298 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZIROxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:53:42 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ69A0-03-076-02
X-M-MSG: 
Date: Fri, 18 Sep 2009 16:51:40 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EDAC, AMD: Fix build error by including <linux/smp.h>
Message-ID: <20090918145140.GE25309@aftab>
References: <1253282699-14611-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253282699-14611-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Sep 2009 14:51:35.0741 (UTC) FILETIME=[850086D0:01CA386F]
X-Reverse-DNS: unknown
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Theodore,

On Fri, Sep 18, 2009 at 10:04:59AM -0400, Theodore Ts'o wrote:
> Accessing the per-cpu variable cpu_llc_id now requires that
> <linux/smp.h> header file be included.
> 
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> 
> This fixes a compile error found in 2.6.31-git6

This was properly fixed in the next snapshot, 2.6.31-git7.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

