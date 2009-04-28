Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZD1TX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZD1TX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZD1TXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:23:19 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:1618 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751223AbZD1TXS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:23:18 -0400
X-BigFish: VPS-22(z34a4jz1432R98dR1805M936fKzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KITSIC-02-FOK-01
Date: Tue, 28 Apr 2009 21:23:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: greg@kroah.com, linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 14/21] amd64_edac: add msr accessors operating on all
	cpus
Message-ID: <20090428192305.GA5008@aftab>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com> <1240931173-17477-15-git-send-email-borislav.petkov@amd.com> <20090428112107.af44e6db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090428112107.af44e6db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 28 Apr 2009 19:23:08.0158 (UTC) FILETIME=[C2F7D1E0:01C9C836]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 11:21:07AM -0700, Andrew Morton wrote:
> I'm all confused.  We interrupt _all_ CPUs and get each one of them to
> write to cmd.data[0] and cmd.data[1].  So what we end up returning is
> the result which was provided by the last CPU which got there,
> whichever CPU that was.
> 
> Am I mising something, or is this all totally screwy?

Gaa, I had fixed those but the patch somehow got lost. Will redo and resend the
whole patchset tomorrow.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

