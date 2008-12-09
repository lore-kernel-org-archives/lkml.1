Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYLIVJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYLIVJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYLIVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:08:47 -0500
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:47069 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751073AbYLIVIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:08:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OidDGWlkZQh6bJDI6c9MheUOvuxENx6VXe7IdHAQks4zMiaeyojM+Ox7gVz0e+bePCW/ABDrM2zs+7TB6D6hmEUrEOn3+dM65SfkB8LgEpLLND6wibiuSdeQVankOaGR;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] sparse irq enabling v5
Date: Tue, 9 Dec 2008 13:08:19 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
References: <1228532315-28799-1-git-send-email-yinghai@kernel.org> <20081208133859.GB29965@elte.hu>
In-Reply-To: <20081208133859.GB29965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091308.23440.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 08, 2008 5:38 am Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> > impact: new feature sparseirq
> >
> > add pointers array as Ingo suggesting.
> > remove dyna_array
> >
> > when sparse_irq is used (CONFIG_SPARSE_IRQ), use kzalloc_node to get
> > irq_desc, irq_cfg use desc->chip_data for x86 to store irq_cfg
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> thanks Yinghai - i've applied your four patches to tip/irq/sparseirq,
> with the changelogs below.
>
> Jesse, any objections to the MSI IRQ renumbering? It's a much saner
> static numbering scheme counting upwards, independent of NR_CPUS.

No, I like the idea of the sparse stuff.  I'd like to get Matthew's ack though 
too; he's been working in this area a bit lately.

Jesse
