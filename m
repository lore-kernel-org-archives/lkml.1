Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbYBKFb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbYBKFb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYBKFbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:31:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:37252 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYBKFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:31:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=QRIz7ydqHLaXw2K8ssQ7w+rgUYxdDod03fbVLW6S9XoZ9+UCD72m3J2JjljSNaq49qjMq4kRYMDjReg9LOVqPKY3amdhI7PwtraSwlXcN2EitnNooqo79Yjr7Q75OZuh63Boi1XNOOSEydEZrVskaK4cPb3V0HHFRNXhnyS1ryU=
Date: Mon, 11 Feb 2008 08:31:13 +0300
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Oops report for the week upto Feb 10th 2008
Message-ID: <20080211053113.GA1736@martell.zuzino.mipt.ru>
References: <47AF9867.6050902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF9867.6050902@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 04:35:51PM -0800, Arjan van de Ven wrote:
> Rank 3: remove_proc_entry
> 	WARN_ON at fs/proc/generic.c:736
> 	Reported 20 times (38 total reports)
> 	This WARN_ON is there if code tries to remove a non-empty /proc 
> 	directory.
> 	Most reports are tainted, pointing at a bug in a binary module.
> 	Without the WARN_ON improvements from 2.6.25-rc1 it'll be hard to 
> 	figure out which module is guilty.

Easy, I'll submit patch RSN.
