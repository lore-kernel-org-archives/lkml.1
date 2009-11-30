Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZK3QLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZK3QLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZK3QLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:11:43 -0500
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:56874 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752668AbZK3QLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:11:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZhlGrmUuZjCzWW3yaZGOUu1eWcgHFAIbDdre0Jl2g9epfjN1heRdAbl54OUROXZNybUynGJVg+EiQTA7a6RDBUJSh6d+ClfYZR6CQEbY51pWGtPWt9zJv6j4wBsVbHAn;
Date: Mon, 30 Nov 2009 08:11:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Stefan Assmann <sassmann@redhat.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
Message-ID: <20091130081147.274c8af0@jbarnes-piketon>
In-Reply-To: <4B126EEB.1040908@garzik.org>
References: <4B110F79.8080405@redhat.com>
	<4B111ADC.9020800@garzik.org>
	<4B123A34.5090509@redhat.com>
	<4B126EEB.1040908@garzik.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009 07:54:03 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Next, IMO, you don't have any idea how maintainers will react to this 
> patch, because you CC'd so few of them.  People who perform tree-wide 
> changes should take the time to CC __every__ relevant maintainer.  If 
> you are changing somebody's code, you should always let them know
> about it, and give them an opportunity to review the change. 
> scripts/get_maintainer.pl can help with this.
> 
> So, while the PCI maintainer might agree with the nomenclature
> change, he is not the most qualified person to state that your
> changes have no effect on drivers/edac/ppc4xx_edac.c, for example.

Honestly I'm not thrilled about it either.  Given the large
downside of making many oustanding diffs conflict, I'm wary of these
sorts of changes in general.  I suggested to Stefan that he just put
together one big patch to minimize that pain, but I didn't expect
something so huge (I was thinking it would be mainly limited to PCI
related files).

-- 
Jesse Barnes, Intel Open Source Technology Center
