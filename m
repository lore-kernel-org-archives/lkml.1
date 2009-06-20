Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZFTU5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZFTU5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZFTU4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:56:46 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:52737 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbZFTU4p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:56:45 -0400
From: Frans Pop <elendil@planet.nl>
To: Sean MacLennan <smaclennan@pikatech.com>
Subject: Re: Badness on the Warp
Date: Sat, 20 Jun 2009 22:56:45 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20090620154824.72b5cd50@lappy.seanm.ca>
In-reply-To: <20090620154824.72b5cd50@lappy.seanm.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906202256.46073.elendil@planet.nl>
X-OriginalArrivalTime: 20 Jun 2009 20:56:47.0073 (UTC) FILETIME=[9FFEF510:01C9F1E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The git bisect returned:
>
>   871fa90791a6f83dd8e2e489feb9534a8c02088d is first bad commit
>
> That is it, no more info.... strange. git show 8714...088d gives:
>
> Merge: 7702667... 79f52b7...
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Jun 11 11:27:09 2009 -0700
>
> The Warp has jfs disabled, so I don't know why it would affect us,
> especially this realy in the boot!

The fact that your bisect ended at a merge essentially means that it is 
invalid. As a merge does not introduce any actual change (unless it 
includes changes to resolve conflicts), it normally cannot be the cause 
of a regression.

So either you made a mistake when marking a commit as good or bad during 
the bisect, or the "badness" does not trigger reliably, resulting in you 
incorrectly marking a bad commit as good.

My suggestion would be to run the bisection again from the start.

Cheers,
FJP
