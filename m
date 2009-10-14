Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZJNVb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZJNVb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbZJNVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:31:56 -0400
Received: from outbound-mail-311.bluehost.com ([67.222.54.4]:53771 "HELO
	outbound-mail-311.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760638AbZJNVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:31:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FEwumhY2hRQnAvOZ74aYCaIOMmseWmz+I2WwUhz3+iD5pVQsjHlG++LMTyv12WEYMK1TRU4AsLccY164ts55DOqFiFVl6e67hamWrKrdSBpnGknwFx/C0kjT466b7BOH;
Date: Wed, 14 Oct 2009 14:30:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [X86] PCI: Use generic cacheline sizing instead of per-vendor
 tests.
Message-ID: <20091014143054.76874f30@jbarnes-g45>
In-Reply-To: <20091014203139.GA2336@redhat.com>
References: <20091014203139.GA2336@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 16:31:39 -0400
Dave Jones <davej@redhat.com> wrote:

> Instead of the PCI code needing to have code to determine the 
> cacheline size of each processor, use the data the cpu identification
> code should have already determined during early boot.
> 
> (The vendor checks are also incomplete, and don't take into account
>  modern CPUs)
> 
> I've been carrying a variant of this code in Fedora for a while,
> that prints debug information.  There are a number of cases where we
> are currently setting the PCI cacheline size to 32 bytes, when the CPU
> cacheline size is 64 bytes.  With this patch, we set them both the
> same.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 

Does this improve performance enough to warrant putting it into the
current cycle?  Or is queuing it for 2.6.33 sufficient?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
