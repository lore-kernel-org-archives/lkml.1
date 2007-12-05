Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbXLEHF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbXLEHF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLEHFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:05:19 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:12294 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXLEHFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:05:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MI0iP7S3enJIayf3IXQ4Sb9YWazw6h/gPejpagFb/ZQDKHyMecG3f4jGVkMaYVYj4e6EJKSLkgorEWHSLuOuwo9VStJ+zNcuU7uYidU9VPKVazThBdvcm+DgpvmiV+CCXc7KVziMda6s67Q4MbyVRrFzL75zeoGWoIlW6oyE6oo=
Date: Wed, 5 Dec 2007 15:01:27 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, sam@ravnborg.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] kbuild: implement modules.order
Message-ID: <20071205070127.GG2460@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <47555AF1.8090304@gmail.com> <20071204150734.GE6113@hacking> <47557076.8080508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47557076.8080508@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I think, you forgot to free(3) the memory you calloc(3)'ed and
>> malloc(3)'ed above.
>
>It's a simple program where whole body is in main().  Why bother?
>What's the benefit of adding hash-table iterating free logic?
>

Personally, I think memory leaks are bugs. And we hate bugs. ;)

Regards.

