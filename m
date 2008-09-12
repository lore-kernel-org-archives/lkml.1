Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYILJt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYILJt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYILJtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:49:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48733 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYILJts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:49:48 -0400
To: "Eunsung Kim" <eskim@arirang.snu.ac.kr>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Performance of "kirqd" in SMP Internet Server
From: Andi Kleen <andi@firstfloor.org>
References: <001f01c914a2$4c856d80$e5904880$@snu.ac.kr>
Date: Fri, 12 Sep 2008 11:49:44 +0200
In-Reply-To: <001f01c914a2$4c856d80$e5904880$@snu.ac.kr> (Eunsung Kim's message of "Fri, 12 Sep 2008 15:39:20 +0900")
Message-ID: <87hc8lsngn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Eunsung Kim" <eskim@dcslab.snu.ac.kr> writes:

> I am looking for improving network interrupt balancing mechanism in SMP
> internet server.
> So I have analyzed kirqd in Linux kernel and I have done the following
> experiment to realize impact of kirqd.

kirqd is deprecated and scheduled to be removed. The replacement 
is user space irqbalanced.

-Andi

-- 
ak@linux.intel.com
