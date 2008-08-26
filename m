Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYHZWlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYHZWlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYHZWlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:41:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61994 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYHZWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:41:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VwV8RKKnR2jkSWCftkGBldP4cSt4nfWcODxi6DMJqX/OmcAxLt9QnLYvEICy1r9Zb
	/mSC+eDLwnnbHHBnFo/vw==
Message-ID: <6599ad830808261540j2b5c46cdsc42e26fa43f3f8d1@mail.gmail.com>
Date: Tue, 26 Aug 2008 15:40:48 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48B39319.7070403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
	 <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
	 <48B39319.7070403@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:22 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> But improving the current code has been on my todo list for a while.
>> My thought on the best way to fix it is to use a proper seq_file -
>> that would remove the issues that you have currently with the
>> "unconsumed" portion of the output.
>
> But for my poor knowledge we always have to handle "unconsumed portion"
> for nonseekable file in all different way. In my binary search based
> solving, I have to handle unconsumed part for a pid and bring in
> some complicated. This is really a disadvantage as you pointed out.

I meant that the seq_file code could handle the "unconsumed" portion
for you, rather than you having to manage it explicitly.

Paul
