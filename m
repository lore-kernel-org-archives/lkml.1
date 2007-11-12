Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXKLXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXKLXrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXKLXrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:47:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbXKLXrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:47:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=dbncB3NmGo+xjUoRYPLhxs7k7O+xlryRvk3JixifFzytbeHDtR7C8xIVdQiaF5WCU
	SvuyWcfE/NUTwwdQIIWWQ==
Message-ID: <6599ad830711121547sd314b61vacde8815be2f8854@mail.gmail.com>
Date: Mon, 12 Nov 2007 15:47:03 -0800
From: "Paul Menage" <menage@google.com>
To: "Diego Calleja" <diegocg@gmail.com>
Subject: Re: [PATCH] Improve cgroup printks
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071110121156.a547194e.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071110121156.a547194e.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 10, 2007 3:11 AM, Diego Calleja <diegocg@gmail.com> wrote:
> When I boot with the 'quiet' parameter, I see on the screen:
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [   39.036026] Initializing cgroup subsys cpuacct
> [   39.036080] Initializing cgroup subsys debug
> [   39.036118] Initializing cgroup subsys ns
>
> This patch lowers the priority of those messages, adds a "cgroup: " prefix
> to another couple of printks and kills the useless reference to the source file.
>
>
> Signed-off-by: Diego Calleja <diegocg@gmail.com>

(with the addition of akpm's KERN_INFO for cgroup_init_subsys() )
Acked-by: Paul Menage <menage@google.com>

Paul
