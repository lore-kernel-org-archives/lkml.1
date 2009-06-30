Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbZF3CNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbZF3CNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZF3CNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:13:24 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:56950 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753184AbZF3CNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:13:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dwpGeBYEXv8jUVGYRttkGdhv4v1tU2/nyCxNh60+3fvbLfnho+GxNoGBN2XKw0eelD9oILXUuvlBGMXDOlRWsdv8mgr6i3yyx4QjWLtQMAERwYx8IyXeRkx3HCclEP65;
Date: Mon, 29 Jun 2009 19:13:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: linux-next: pci tree build failure
Message-ID: <20090629191324.5c86bbc0@jbarnes-g45>
In-Reply-To: <20090630120727.24450bab.sfr@canb.auug.org.au>
References: <20090630120727.24450bab.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 12:07:27 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> ERROR: "pci_claim_resource" [drivers/pcmcia/yenta_socket.ko]
> undefined!
> 
> Caused by commit 6bb04b65dbff5a5bb01617351dbb0af577084752 ("yenta: Use
> pci_claim_resource").  yenta can be built as a module, but
> pci_claim_resource is not exported ...
> 
> I have used the pci tree from next-20090629 for today.

Damn, thought I built that.  linux-next earns its keep yet again.

-- 
Jesse Barnes, Intel Open Source Technology Center
