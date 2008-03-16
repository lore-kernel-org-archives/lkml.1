Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYCPX1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYCPX1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYCPX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:26:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbYCPX03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:26:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=GkBOjEuG4OXAg4I1EpKJ8SUOMtqrYRa+dTt7DgssoX9lrlAxIZZdimgKyBcCidZBP
	apK/yHbIG/MGvtnzaUzBw==
Message-ID: <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
Date: Mon, 17 Mar 2008 07:26:22 +0800
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> This is an early patchset for virtual address space control for cgroups.
>  The patches are against 2.6.25-rc5-mm1 and have been tested on top of
>  User Mode Linux.

What's the performance hit of doing these accounting checks on every
mmap/munmap? If it's not totally lost in the noise, couldn't it be
made a separate control group, so that it could be just enabled (and
the performance hit taken) for users that actually want it?

Paul
