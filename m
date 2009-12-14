Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZLNKKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZLNKKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZLNKKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:10:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:43000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbZLNKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kcltUayjtOkFhfyYb4eT0zx4pBg5kCU+EDywN4qsrgP2pOxrp56UM66+EPIINuqGNF
         MFTg6pWowJYBSVygjvTrj3kK0f0i+vSt19TRKQQbtQoxxzxmVqh52YOEgBa4bIWLeJY3
         hAnOe/Y4tt0D8oaUC/z9HL4gD3l64683M8+vk=
Message-ID: <4B260F25.6070908@gmail.com>
Date: Mon, 14 Dec 2009 11:10:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-13.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the limits tree with Linus' tree
References: <20091214143909.a7b6dcf1.sfr@canb.auug.org.au>
In-Reply-To: <20091214143909.a7b6dcf1.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2009 04:39 AM, Stephen Rothwell wrote:
> Today's linux-next merge of the limits tree got a conflict in
> arch/ia64/kernel/sys_ia64.c between commit
> bb52d6694002b9d632bb355f64daa045c6293a4e ("Get rid of open-coding in
> ia64_brk()") from Linus' tree and commit
> d9ef7d0ce61f214180f505b78cdf8f9b3d862dfa ("IA64: use helpers for
> rlimits") from the limits tree.
> 
> The former removed the code that the latter was updating.  A merge with
> Linus' tree will fix this up, but it is pretty trivial anyway.

Hi.

Thanks, I fixed all 3 conflicts.

-- 
js
