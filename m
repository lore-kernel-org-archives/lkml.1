Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbYGSKST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbYGSKST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYGSKSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:18:10 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:34189 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYGSKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r2+5qGKeHJBWOBbXjLUVApVt737cVrRddOD+HyLrE9b9CSEEKCLxv3q2V2X/CubV2K
         XHhHcExDVIRieboe3q9PdF/7FikO9K2luRh3/jcbEd3cB+w2ThdMrAsX2VLEzoofmlLk
         q+F5xp9iJIIKLKADKba/bwvcl4WOTvkUYrn2s=
Date: Sat, 19 Jul 2008 11:16:35 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: [Patch] kexec: remove redundant if-else
Message-ID: <20080719101635.GB3558@hack.netcabo.pt>
References: <20080718150410.GB26261@hack.voiplan.pt> <m1sku7j6qp.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sku7j6qp.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 01:07:58PM -0700, Eric W. Biederman wrote:
>WANG Cong <xiyou.wangcong@gmail.com> writes:
>
>> These if-else's can be removed.
>
>Why?  That appears to be pointless code style thrashing.


I don't think that is coding style fix. Because when we arrive the
'out' branch, 'result' is always properly set, thus checking it again
is useless for me. :-)

Thanks.

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
