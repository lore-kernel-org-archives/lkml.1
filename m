Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbYDUPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbYDUPtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYDUPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:48:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35607 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYDUPsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:48:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=bqlMvv6Sv1KnExOYQeCZZ7NegC6WmX2db4WVPLhOFvJeMZO0BsE+aATpI1IuAjyjQ
	tHGQgHiAaN+7mLdW+EC6w==
Message-ID: <6599ad830804210848v754a3aaex6b963dc2e12327fd@mail.gmail.com>
Date: Mon, 21 Apr 2008 08:48:30 -0700
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
Cc: balbir@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com,
       xemul@openvz.org, shiwh@cn.fujitsu.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
In-Reply-To: <1208770925.7115.167.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0804210004470.1630@blonde.site>
	 <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080420232427.1b399104.akpm@linux-foundation.org>
	 <480C347C.6060702@linux.vnet.ibm.com>
	 <20080421064725.GA32214@balbir.in.ibm.com>
	 <1208770925.7115.167.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 2:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>  > This would enable the memory controller by default, it can be disabled
>  > using cgroup_disable=memory at boot time.
>
>  how about working on a runtime switch that only enables the whole
>  memcgroup machinery when an actual cgroup gets created - and disable it
>  again once the last cgroup goes.
>

Or more specifically, enable memory tracking when the mem controller
gets bound to a cgroup hierarchy, and disable it when the controller
is unbound.

Paul
