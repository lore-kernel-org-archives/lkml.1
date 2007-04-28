Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXD1Hoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXD1Hoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXD1Hop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:44:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:60115 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbXD1Hoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HUQ/s3QBwhwNsPcyW7pK/c1niFfd1KliRHlkJ0lbiwOESk9IH8b5I8dM7FjYgsafFujFWMCW0QG9KWvrPUReLeOKFcs7liN9gO3OnjGj+IdxI8CvOk+Lr5J/Xvqgh5XXlJ6Sqo4pN2OIG0SaA9fAHMPi1rUI3HlPGtrTjse/Zhg=
Message-ID: <b6fcc0a0704280044i3ff820b6w343bd73c7a08f708@mail.gmail.com>
Date: Sat, 28 Apr 2007 11:44:43 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH] hugetlbfs: fix error path in module_init
Cc: linux-kernel@vger.kernel.org, "William Irwin" <wli@holomorphy.com>
In-Reply-To: <20070428071923.GB9545@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070428071923.GB9545@APFDCB5C>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> init_hugetlbfs_fs() needs to unregister hugetlbfs
> when kern_mount() returns error.

HUGETLBFS is bool, so __init function should panic more and
__exit function should be removed. Or someone is planning
making it tristate?
