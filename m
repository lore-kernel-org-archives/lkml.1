Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYIHEg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYIHEg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYIHEgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:36:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYIHEgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:36:19 -0400
Message-ID: <48C4A95F.5040900@zytor.com>
Date: Sun, 07 Sep 2008 21:26:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Ingo Molnar <mingo@elte.hu>, Luca Tettamanti <kronos.it@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [2.6.27] overlapping early reservations [was: early exception
 	- lockdep related?]
References: <b8P0N-3Dp-11@gated-at.bofh.it> <b8PaB-3Or-23@gated-at.bofh.it> <b8Q6x-51x-11@gated-at.bofh.it> <b961C-rW-9@gated-at.bofh.it> <b97qL-26L-15@gated-at.bofh.it> <E1KcNQE-0001Le-8P@be1.7eggert.dyndns.org>
In-Reply-To: <E1KcNQE-0001Le-8P@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> 
> I don't think ignoring an intrd will be as serious, but having a panic (and
> a timeout) is preferable to starting the wrong configuration.
> 

Most of the time, ignoring the initrd would result in a panic anyway, 
and arguably the times it wouldn't, it's going to do something wrong.

	-hpa
