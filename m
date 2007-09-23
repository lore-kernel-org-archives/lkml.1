Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXIWBF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXIWBF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXIWBFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:05:17 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:57003 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXIWBFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:05:16 -0400
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Should parent's WIFSIGNALED(siginfo->si_status) be true EVEN IF the SIGNAL was caught by the child?
Date: Sat, 22 Sep 2007 18:05:07 -0700
User-Agent: KMail/1.9.6
References: <200709221122.09523.jzb2@aexorsyst.com> <200709221318.53579.jzb2@aexorsyst.com> <jezlzeuvc3.fsf@sykes.suse.de>
In-Reply-To: <jezlzeuvc3.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709221805.07463.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 16:35:56 Andreas Schwab wrote:
> "John Z. Bohach" <jzb2@aexorsyst.com> writes:
> >     if (WIFEXITED(siginfo->si_status))
>
> That does not make any sense.  si_status is _not_ a wait status.
>
> Andreas.

Thank you for clearing that up.  That explains it.

--john
