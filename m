Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZBRTA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZBRTA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZBRTAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:00:50 -0500
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:52265 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752268AbZBRTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:00:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=MNAbwfYyn6rY+WoChGm8H7eRK+CqiJ1kPga9ogTKXpbBcvdWh6VN9hXA28wsTGZFw5cOEY/wO0CcysE9sUsHqaeaPbDjKnDtdPuO5FFkSA09J3t9YPhuve9/pEfjjIKt;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 11:00:18 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B9129.50104@kernel.org>
In-Reply-To: <499B9129.50104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181100.18928.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 8:40 pm Yinghai Lu wrote:
> Impact: workaround BIOS that doesn't enable that bit
>
> David reported that LSI sas doesn't work with MSI.
> it turns out that BIOS doesn't enable HT MSI
> 8132 does support HT MSI.
> add quirk to enable it
>
> Reported-by: David Lang <david@lang.hm>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
