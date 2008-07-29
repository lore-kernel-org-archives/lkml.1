Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbYG2Q1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbYG2Q1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2Q1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:27:42 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:16870 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYG2Q1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Q0QYgd/1DymtmRFHuJmjYkcf1OBnqyokUR+6PNIkJLxU/f2w8NP4GnrfVfzADb7tVp
         sF6HD48XMYpYp+fSRiyR5YQdbu0czXULiVgj0sJNQ8gcePAm5uKN4Ptz1bbcy3q0GmSa
         WxuRX+MV3VAWNfR7gAshTq8fvHLtq6DAwZztE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 29
Date: Tue, 29 Jul 2008 18:25:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Hansen <haveblue@us.ibm.com>, Greg KH <gregkh@suse.de>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
In-Reply-To: <20080729172337.b3d74100.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807291825.14281.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 29 July 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080728:

I keep reverting commit 0e3638d1e04040121af00195f7e4628078246489 ("warn
when statically-allocated kobjects are used") with each linux-next release
to make it work on my x86_32 laptop (http://lkml.org/lkml/2008/7/19/114).

Depending on the day I either forget to revert it on a first try or (lead by
incurable optimism) I don't try to revert it in hope that it was fixed.

Unfortunately the result is always the same cursing-during-qemu-test-run
-> git-revert -> recompile cycle and a needless time loss.

Could we have some action taken please?

Thanks,
Bart
