Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbYCUVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbYCUVI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYCUVIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:08:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57787 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYCUVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:08:10 -0400
Subject: Re: r-o bind in nfsd
From: Dave Hansen <haveblue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-Reply-To: <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
	 <20080321155451.GU10722@ZenIV.linux.org.uk>
	 <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
	 <20080321163520.GV10722@ZenIV.linux.org.uk>
	 <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
	 <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
	 <20080321181105.GW10722@ZenIV.linux.org.uk>
	 <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 14:08:01 -0700
Message-Id: <1206133681.30471.37.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 19:52 +0100, Miklos Szeredi wrote:
> Traditionally we have syscalls, and nfsd.  Both of them want the
> security checks, and I think nfsd wants the read-only mount checking
> as well, but I'm not entirely sure.  Maybe we can handle that by just
> making nfsd acquire a write-ref on the mount and keep it while it's
> exported.

The only question for me would be where the current r/o checks are
happening (IS_RDONLY()).  I generally based my patches on replacing
those calls.  

-- Dave

