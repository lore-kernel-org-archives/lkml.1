Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZAVQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZAVQEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 11:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZAVQEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 11:04:25 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:62162 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZAVQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N0jLikWrcd7mFkrEHP7CAkpD04wlTR3dg8SBVybwhO17MrybUaL8o8QmmeQgj07DYQ
         pQxgp28rIsWSJ9nd0uwgxVcWTI31NZJYLBx0zEoGEY418UGUv0ybDSr8TJ/uUE8WTejK
         7ZTUsqB11wD5E3RpuNZ7edaqWWOJxS27TrOw8=
Date: Fri, 23 Jan 2009 00:04:01 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86, um: fix GETREG/PUTREG macros
Message-ID: <20090122160401.GA9732@hack.private>
References: <49773C2E.9090608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49773C2E.9090608@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 04:15:58PM +0100, Roel Kluin wrote:
>When these macros aren't called with regs, e.g. with foo
>this will incorectly expand to foo->foo.gp[*]
>
>Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Good catch!

Reviewed-by: WANG Cong <wangcong@zeuux.org>

-- 
"Against stupidity, the gods themselves, contend in vain."

