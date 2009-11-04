Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZKDSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZKDSSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757539AbZKDSSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:18:24 -0500
Received: from outbound-mail-147.bluehost.com ([67.222.38.37]:48489 "HELO
	outbound-mail-147.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755192AbZKDSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:18:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JgeKrymMGAHrgGVAhxmIeTr2qdSlQW4OzXIDZzkcQxz8DW/mRJ+al0AvcfeCMlQoLqRJP+iBFkYt6smLFP3QoteBjxtFOi9wxxoRbtCoZ4dJYcEWF64gX4xAUaGQDJ4l;
Date: Wed, 4 Nov 2009 10:18:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org, Alex Chiang <achiang@hp.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: remove pci_find_slot from PCI_LEGACY config
 description
Message-ID: <20091104101825.5e80c974@jbarnes-piketon>
In-Reply-To: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com>
References: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 17:46:48 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> Commit 3b073eda has removed pci_find_slot, so there's no point in
> mentioning it in the config description as one of the deprecated APIs
> there are enabled by PCI_LEGACY and still used by some drivers.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---

Applied to linux-next.  You can do the suggested pci.txt stuff in a
followup if you want.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
