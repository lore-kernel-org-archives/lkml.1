Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZHGKyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZHGKyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 06:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZHGKyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 06:54:22 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:61666 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812AbZHGKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 06:54:21 -0400
From: Frans Pop <elendil@planet.nl>
To: Henk Martijn <h.h.martijn@gmail.com>
Subject: Re: [bisected] boot speed regression in current git
Date: Fri, 7 Aug 2009 12:54:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A7BFCC4.8060006@gmail.com>
In-reply-To: <4A7BFCC4.8060006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071254.20163.elendil@planet.nl>
X-OriginalArrivalTime: 07 Aug 2009 10:54:20.0524 (UTC) FILETIME=[6ACD4AC0:01CA174D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I bisected this to "net: restore the original spinlock to protect
> unicast list" commit: a6ac65db2329e7685299666f5f7b6093c7b0f3a0
> reverting this commit gives me back 20 s in boot time.

Try adding this patch from Ingo. It will probably fix the issue:
http://marc.info/?l=linux-kernel&m=124945666109347&w=2

Cheers,
FJP
