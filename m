Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab0BIT5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:57:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab0BIT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:57:29 -0500
Date: Tue, 9 Feb 2010 11:56:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 06/35] x86/pci: add cap_resource
Message-Id: <20100209115606.b2974201.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-7-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-7-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:17 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> +static inline resource_size_t cap_resource(u64 val)
> +{
> +	if (val > MAX_RESOURCE)
> +		return MAX_RESOURCE;
> +	else
> +		return val;
> +}

	return min(val, MAX_RESOURCE);
