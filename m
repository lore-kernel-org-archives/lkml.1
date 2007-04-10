Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXDJKen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXDJKen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 06:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbXDJKem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 06:34:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbXDJKel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 06:34:41 -0400
Date: Tue, 10 Apr 2007 12:33:45 +0200
From: Karel Zak <kzak@redhat.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
Message-ID: <20070410103345.GM31445@petra.dvoda.cz>
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org> <E1Ha4cN-0004rc-00@dorka.pomaz.szeredi.hu> <20070409143802.GB4891@sergelap.austin.ibm.com> <E1Hawf4-0000E7-00@dorka.pomaz.szeredi.hu> <20070409170743.GF24415@sergelap.austin.ibm.com> <1176140785.2842.18.camel@ram.us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176140785.2842.18.camel@ram.us.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 10:46:25AM -0700, Ram Pai wrote:
> On Mon, 2007-04-09 at 12:07 -0500, Serge E. Hallyn wrote:
> > Quoting Miklos Szeredi (miklos@szeredi.hu):
> 
> > >  - need to set up mount propagation from global namespace to private
> > >    ones, mount(8) does not yet have options to configure propagation
> > 
> > Hmm, I guess I get lost using my own little systems, and just assumed
> > that shared subtree functionality was making its way up into mount(8).
> > Ram, have you been working on that?
> 
> It is in FC6. I dont know the status off upstream util-linux. I did
> submit the patch many times to Adrian Bunk (the then util-linux
> maintainer) and got no response. I have not pushed the patches to the
> new maintainer(Karel Zak?) though.

 The "shared-subtree" patch has been applied:
 http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=commitdiff;h=389fbea536e4308d9475fa2a89e53e188ce8a0e3;hp=939a997de0c761d29fb7530976ca20da4898703a

 
    Karel

-- 
 Karel Zak  <kzak@redhat.com>
