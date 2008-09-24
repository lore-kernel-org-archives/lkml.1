Return-Path: <linux-kernel-owner+w=401wt.eu-S1753744AbYIXVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbYIXVT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYIXVTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:19:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:54561 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbYIXVTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:19:44 -0400
Date: Thu, 25 Sep 2008 07:18:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
In-Reply-To: <20080924132855.GB10756@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0809250715030.5963@tundra.namei.org>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp> <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
 <48D9F399.4070002@nttdata.co.jp> <20080924132855.GB10756@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008, Serge E. Hallyn wrote:

> Quoting Kentaro Takeda (takedakn@nttdata.co.jp):

[please trim quoted material..]

> > 
> > +config SECURITY_PATH
> > +	bool "Security hooks for pathname based access control"
> > +	depends on SECURITY
> > +	help
> > +	  This enables the security hooks for pathname based access control.
> > +	  If enabled, a security module can use these hooks to
> > +	  implement pathname based access controls.
> > +	  If you are unsure how to answer this question, answer N.
> 
> Is there any reason why users should have to deal with this option?
> Would it make sense in this case to make the option and have tomoyo and
> apparmor select it?

Who are users in this case?  It's probably useful as a separate option for 
testing purposes and for people doing development.  LSMs which depend on 
it should probably still use SELECT in any case.

-- 
James Morris
<jmorris@namei.org>
