Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbZJ3R6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbZJ3R6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 13:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932759AbZJ3R6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 13:58:53 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:36822 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbZJ3R6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 13:58:53 -0400
Message-ID: <4AEB2885.5040406@nortel.com>
Date: Fri, 30 Oct 2009 11:55:17 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: Arnd Bergmann <arnd@arndb.de>, "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com> <4AE63FA3.8040208@us.ibm.com> <200910290939.32485.arnd@arndb.de> <4AEA3F15.2070900@us.ibm.com> <4AEA4547.30102@us.ibm.com>
In-Reply-To: <4AEA4547.30102@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2009 17:58:42.0703 (UTC) FILETIME=[9E2479F0:01CA598A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 07:45 PM, Darren Hart wrote:

> This appears to work fine. Can anyone think of a reason why this is an unsafe
> thing to do? I'll have to create a much more elaborate test case and review
> the glibc code of course to make sure the glibc mutex state isn't compromised.

Setting aside the specific code details, I would suggest that you not
review the glibc code but rather review the glibc documentation and the
susv3/posix specifications.  That way, if it behaves according to the
spec but breaks glibc you can push for a patch to glibc.

If it happens to work with current glibc but is not standards-compliant,
then it could break in the future.

Chris
