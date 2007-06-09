Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbXFIIVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbXFIIVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbXFIIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:21:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbXFIIVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:21:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Vz01Ktz04iJkxD8swgIhDQcAVAEDJAqO+FVTIkhj2jhvZpTRKj8buif3X14hBmz04
	0BHgdpj37jgYHyLUZJbbg==
Message-ID: <6599ad830706090120i6ba8686ep1abffd6cc4cd81e3@mail.gmail.com>
Date: Sat, 9 Jun 2007 01:20:55 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <20070609011740.fc938ed6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop>
	 <20070608124816.fa1e70d8.akpm@linux-foundation.org>
	 <6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
	 <20070609010202.4c2b51fb.akpm@linux-foundation.org>
	 <6599ad830706090107u63b7e8c2p8e5c65778cde7473@mail.gmail.com>
	 <20070609011740.fc938ed6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Would it not be simplest to have CONTAINERS as the top-level
> user-configurable item and to then have everything else depend on it?
>

Yes, OK - it can go that way around too. I guess my thought was that
people would be more interested in enabling/disabling the subsystems
themselves (cpusets, RSS, etc) than the underlying framework. But if
select has problems then it's no trouble to invert it.

Paul
