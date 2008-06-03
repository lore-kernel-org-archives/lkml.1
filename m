Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYFCLwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYFCLwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYFCLwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:52:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:33212 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYFCLwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DrV40T3yaw3cdBEgouYGld81uABIhZdHpWRgkc14Pq5qsg2O7iXDYnwCPZmlasmKyOqcfybVWkKq025WCU3Cj+a9ZxBQUzkAxv8bO/24VBfzi7QHYEi5ALQ3mWfP3gNLDpvHcMjkH+ToUm6vEVE8qJF1VaHQuettlmaAENaPhM8=
Message-ID: <cfd18e0f0806030452n32fa6d4dke1e2e4443a361a3@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:52:20 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
	 <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
	 <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 1:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > I'm not sure of the correct way to get the required nameidata (to do a
>> > vfs_permission() call) from the file descriptor.  Can you give me a
>> > tip there?
>>
>> Could you point me at the right way of doing this?
>
> You don't need nameidata for this at all.  Just call permission() with
> a NULL nameidata.

Thanks Miklos!
