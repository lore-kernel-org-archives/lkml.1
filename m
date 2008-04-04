Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYDDNel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYDDNel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYDDNe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:34:28 -0400
Received: from www.tglx.de ([62.245.132.106]:53638 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759414AbYDDNe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:34:27 -0400
Date: Fri, 4 Apr 2008 15:33:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balaji Rao <balajirrao@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Yanko Kaneti <yaneti@declera.com>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
In-Reply-To: <pdYe6zNQVl.A.KN.1DW9HB@albercik>
Message-ID: <alpine.LFD.1.10.0804041531001.3224@apollo.tec.linutronix.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.KN.1DW9HB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.

Yes, it is. The revert of the patch which caused that is queued for
todays push to Linus.

Thanks,

	tglx

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10382
> Subject		: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
> Submitter	: Yanko Kaneti <yaneti@declera.com>
> Date		: 2008-04-02 10:59 (2 days old)
> References	: http://lkml.org/lkml/2008/4/2/210
> Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 		  Balaji Rao <balajirrao@gmail.com>
> 
> 
