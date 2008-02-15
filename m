Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYBOTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYBOTng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYBOTnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:43:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:37488 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYBOTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:43:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xH9xs+bxD5b8cG1566SzlFdtlcHpCnUeTUiBEOgOVry3a13gKE/uMXx4pJjXUzczCaIhrtY6L+axTQjoHz2EWLYmAn31sXCpjNnZdr5v+0258e2DM8XVXiGcaMonpt/izvC9QjvQ1CbyP+f6esSz78A0/kdA16e5CNGkk3qXmkY=
Message-ID: <3cce60f30802151143gc98e3a2l29aa49f8f829e2f6@mail.gmail.com>
Date: Fri, 15 Feb 2008 11:43:09 -0800
From: "Shannon Nelson" <shannon.lee.nelson@gmail.com>
To: "Laurent CORBES" <laurent.corbes@smartjog.com>
Subject: Re: [BUG] OOPS 2.6.24.2 raid5 write with ioatdma
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>
In-Reply-To: <20080215171905.2e5c6bee@smartjog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215171905.2e5c6bee@smartjog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 8:19 AM, Laurent CORBES
<laurent.corbes@smartjog.com> wrote:
> Hi all,
>
>  I got a raid5 oops when trying to write on a raid 5 array, with ioatdma loaded
>  and without DCA activated in bios:
>
[...]

Dan's quick patch is likely the right answer.

>
>  When I enable DCA in system bios I cannot boot, the ioatdma subsystem failed to
>  initialize, it stalled at:
>  ioatdma: ioat_dma_test_callback(00008086)

I don't see this example in the dmesg, but I'm not sure why you think
this is the case.  If DCA is enabled, you should not see any further
messages from ioatdma after the ioat_self_test_callback().

sln
-- 
==============================================
Mr. Shannon Nelson Parents can't afford to be squeamish.
