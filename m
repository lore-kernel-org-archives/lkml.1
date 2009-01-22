Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZAVQIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZAVQIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbZAVQIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:08:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:10123 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZAVQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FHAS/V+xbONiZFMN/PkxWwTYIsY7z9ZrZLqZLIYZu8+NnvdF541y0ONKXD3cgz25VS
         f47+8pqmAXtxOzplrLNR8FJCOIvll1GMSrNGKeOzSN9VTbIuvO78h0W+wNu5zBReQcvJ
         6DY+GBlIG8aTre/wRFqlhrcUX3DIA3SIu2e+c=
Date: Fri, 23 Jan 2009 00:07:51 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, um: fix ELF_CORE_COPY_REGS macro
Message-ID: <20090122160751.GC9732@hack.private>
References: <497739E6.4010806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497739E6.4010806@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 04:06:14PM +0100, Roel Kluin wrote:
>When this macros isn't called with regs, e.g. with foo
>this will incorectly expand to foo->foo.gp[*]
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Reviewed-by: WANG Cong <wangcong@zeuux.org>


-- 
"Against stupidity, the gods themselves, contend in vain."

