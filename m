Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXGVXK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXGVXK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761984AbXGVXKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:10:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:40144 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbXGVXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dA4DVWfrO250tmnyznpAursvNDPCfrzAvGTPipDElWSJtTjY+FFvRgjb0xBsx1X4MgcMV5cB0GmM8u0vES7N4ridC0ADK4zLG1TrCM655nfhBRYxZlLhuTTlBZfGbvV1mSMSOdEqNUo0HBD9HcrS3prRysUVp4OynGSGkH6KJXI=
Message-ID: <86802c440707221610i112c3527p40f188f4afcad31c@mail.gmail.com>
Date: Sun, 22 Jul 2007 16:10:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: NFS mount gives ENETDOWN in -git15
Cc: netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707211531.17750.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211531.17750.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Andi Kleen <ak@suse.de> wrote:
>
> I tried to mount another nfs mount on a system running with nfsroot.
> But I get
>
> # mount basil:/home /basil/home/
> mount: Network is down
>
> The network is not down of course, the system is happily running with nfs root from that
> server. Userland is older SUSE 10.0
>
> Excerpt from strace mount:
>
> -Andi
>

What is your CONFIG_NETDEVICES_MULTIQUEUE in .config?

YH
