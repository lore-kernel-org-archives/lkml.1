Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYLYBRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYLYBRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 20:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLYBRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 20:17:09 -0500
Received: from tundra.namei.org ([65.99.196.166]:2390 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYLYBRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 20:17:06 -0500
Date: Thu, 25 Dec 2008 12:17:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Sergio Luis <sergio@larces.uece.br>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       LSM <linux-security-module@vger.kernel.org>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smackfs: check for allocation failures in
 smk_set_access()
In-Reply-To: <49507107.4010809@schaufler-ca.com>
Message-ID: <alpine.LRH.1.10.0812251215450.27964@tundra.namei.org>
References: <494F148F.8070101@larces.uece.br> <49507107.4010809@schaufler-ca.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Casey Schaufler wrote:

> Sergio Luis wrote:
> >  smackfs: check for allocation failures in smk_set_access() 
> >  While adding a new subject/object pair to smack_list, smk_set_access()
> >  didn't check the return of kzalloc(). 
> >  This patch changes smk_set_access() to return 0 or -ENOMEM, based on
> > kzalloc()'s return. It also updates its caller, smk_write_load(), to
> >  check for smk_set_access()'s return, given it is no longer a void  return
> > function.
> > 
> >  Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> >  To: Casey Schaufler <casey@schaufler-ca.com>
> >  Cc: Ahmed S. Darwish <darwish.07@gmail.com>
> >  Cc: LSM <linux-security-module@vger.kernel.org>
> >  Cc: LKLM <linux-kernel@vger.kernel.org>
> >   
> 
> Acked-by: Casey Schaufler <casey@schaufler-ca.com>
> 

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

I'll push this to Linus after he pulls the main security update, or with 
it on re-send.

-- 
-- 
James Morris
<jmorris@namei.org>


