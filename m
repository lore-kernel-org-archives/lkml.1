Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYGATBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYGATBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 15:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYGATBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 15:01:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48592 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYGATBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 15:01:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NnqQDhc5jyf0GjL8bm1wlGG4fCmpkIT4pp189MhgnSpniR9ITpNFO7tNhPfB9TdzY
	f9yaWyGpou34Xxpv6/2UQ==
Message-ID: <6599ad830807011201g1e6cba65w5cb6554073988d3e@mail.gmail.com>
Date: Tue, 1 Jul 2008 12:01:27 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: Attaching PID 0 to a cgroup
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <486A06B7.7020906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701094545.GD3925@linux.vnet.ibm.com>
	 <20080701094734.GE3925@linux.vnet.ibm.com>
	 <486A06B7.7020906@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 3:28 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Why is it unexpected? it follows the behavior of cpuset, so this patch will
> break backward compatibility of cpuset.

Agreed. I think we want to keep this behaviour.

Paul
