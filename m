Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZLDIuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZLDIuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZLDIuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:50:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41685 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZLDIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:50:03 -0500
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       <netdev@vger.kernel.org>
References: <20091204193613.8986a3c6.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 04 Dec 2009 00:50:04 -0800
In-Reply-To: <20091204193613.8986a3c6.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Fri\, 4 Dec 2009 19\:36\:13 +1100")
Message-ID: <m1ocmfdsxv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: linux-next: manual merge of the sysctl tree with the net tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> Today's linux-next merge of the sysctl tree got a conflict in
> kernel/sysctl_check.c between commit
> 8153a10c08f1312af563bb92532002e46d3f504a ("ipv4: add sysctl to accept
> packets with local source addresses") from the net tree and commit
> 83ac201b4f06eb8aeb7ac93cf162651ba30e0b28 ("sysctl: Remove dead code from
> sysctl_check") from the sysctl tree.
>
> The latter removes the need for the former to change this file.  I just
> used the latter.

Rats.  I feel blind.  I totally missed the fact that sysctl_check was
changed in that one.

Eric
