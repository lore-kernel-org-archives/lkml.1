Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYJLRiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYJLRiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 13:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYJLRii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 13:38:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9894 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbYJLRih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 13:38:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cp78K9YhJOWsGRApeamgqCXMoS7Y5K7HhqYy/YyXDbcEVVjSARZOoCn7gSwuo4BpK
	ObM7ktS9THE0hjNrVblGg==
Message-ID: <6599ad830810121038y12863028o81b7c8f35bca8138@mail.gmail.com>
Date: Sun, 12 Oct 2008 10:38:28 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 3/4] cpuset: use seq_*mask_* to print masks
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "Paul Jackson" <pj@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48F1C378.6020202@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F1C378.6020202@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 2:29 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> 1) seq_file excepts that m->count == m->size when it's buf is full,
>   so current code will causes bugs when buf is overflow.
>
> 2) There is not too good that cpuset accesses struct seq_file's
>   fields directly.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>
