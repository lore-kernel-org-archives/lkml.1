Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbXHVLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbXHVLMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 07:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXHVLMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 07:12:40 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:53297 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXHVLMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 07:12:39 -0400
Message-ID: <46CC1A24.5030509@de.ibm.com>
Date: Wed, 22 Aug 2007 13:12:36 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>, ltp-announce@lists.sourceforge.net,
       ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Ltp-coverage] [ANNOUNCE] GCOV & LCOV Packages Released
References: <46CC0216.4040200@linux.vnet.ibm.com>	<p737innzvis.fsf@bingen.suse.de> <661de9470708220315l24c5313by50b9c027d0e38ba2@mail.gmail.com>
In-Reply-To: <661de9470708220315l24c5313by50b9c027d0e38ba2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> On 22 Aug 2007 12:57:47 +0200, Andi Kleen <andi@firstfloor.org> wrote:
>> Have you considered submitting these patches for review to mainline?
> I second that, it would be nice to have these features in mainline instead of
> maintaining them for every kernel release.

Actually yes, I did and am still considering to do that. Still I feel that there are a few things that need to be changed in the gcov-kernel code before it's suitable for inclusion into mainline (e.g. move from use of /proc to debugfs, use of seqfile mechanism instead of custom code). Part of that work has already been done by yyangcdl@cn.ibm.com and myself but we've stalled about half-way due to a lack of time.

Seeing that there seems to be some support for the idea, I'll try to come up with a patch for further discussion.


Regards,
  Peter Oberparleiter
