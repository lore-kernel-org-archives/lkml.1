Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYFXNlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYFXNlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYFXNla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:41:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:8921 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017AbYFXNlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cB3KwVz3nSpeBUVmT/1K1i7XKsJ9drDcS9vpRusJepm7iOCfQHXQb9eDAQK+SjIDJP
         /KYnW/GDIcZzVxY8URmCCHbf3E1S+uzwQnZw5BTCFvBbPK1/plGTBBFNXW9VfVag2+m+
         2xo7+M50i6LAxWLuzLLW97gTbk6aI2Q1yfFyU=
Message-ID: <3877989d0806240641r490e77d0u622b1cb2bb9e830b@mail.gmail.com>
Date: Tue, 24 Jun 2008 21:41:15 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Robin Holt" <holt@sgi.com>
Subject: Re: [BISECT] Boot failure on ia64.
Cc: tony.luck@intel.com, "Alex Chiang" <achiang@hp.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080624123014.GJ10123@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080624123014.GJ10123@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 8:30 PM, Robin Holt <holt@sgi.com> wrote:
> I bisected to this commit 3463a93def55c309f3c0d0a8aaf216be3be42d64
>
> 3463a93def55c309f3c0d0a8aaf216be3be42d64 is first bad commit
> commit 3463a93def55c309f3c0d0a8aaf216be3be42d64
> Author: Alex Chiang <achiang@hp.com>
> Date:   Wed Jun 11 17:29:27 2008 -0600
>
>    [IA64] Update check_sal_cache_flush to use platform_send_ipi()
> ...
>
> This fails to boot on any sn2 ia64 with the sn2_defconfig.

how about CONFIG_IA64_GENERIC?
