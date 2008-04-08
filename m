Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbYDHGQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbYDHGQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYDHGQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:16:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYDHGQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:16:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ylzK8SbqGrVNCHAwLSxfO+XBe7Yjzyqt0AmvoO1V3WdY3jOiboF5aQVvuxVH6Zxgm
	QJSVkLZjlAK1JCGmep2gA==
Message-ID: <6599ad830804072316q441a1816o11f39ee7f9b49c0f@mail.gmail.com>
Date: Mon, 7 Apr 2008 23:16:23 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Hirokazu Takahashi" <taka@valinux.co.jp>
Subject: Re: [PATCH 1/3] accounting: task counters for disk/network
Cc: "Gerlof Langeveld" <gerlof@atcomputing.nl>, linux-kernel@vger.kernel.org,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>
In-Reply-To: <20080407231007.4946410d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080402073037.GA8419@atcmpg.ATComputing.nl>
	 <20080403125416.ead5cd38.akpm@linux-foundation.org>
	 <20080408054837.GA7103@atcmpg.ATComputing.nl>
	 <20080407231007.4946410d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 11:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  This sort of accounting will presumably be needed by a disk bandwidth
>  cgroup controller.  Perhaps the containers/cgroup people have plans of code
>  already?
>

Yes, there have been various cgroup block-I/O subsystems proposed. I
know that at least the one posted by Hirokazu Takahashi
<taka@valinux.co.jp> uses the same per-page cgroup pointer as the
memory controller.

Paul
