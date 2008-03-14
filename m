Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYCNPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYCNPpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYCNPpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:45:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60662 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbYCNPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:45:39 -0400
Date: Fri, 14 Mar 2008 10:45:37 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Greg KH <greg@kroah.com>,
       James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314154537.GA6604@sergelap.austin.ibm.com>
References: <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <20080314044741.GB18077@kroah.com> <20080314135416.GD8744@sergelap.austin.ibm.com> <47DA848C.3070901@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA848C.3070901@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> [snip]
> 
> >> My main question was why was that file in the kernel/ directory?
> >> Shouldn't that also be in the security/ directory?
> > 
> > I'm using cgroups to track the tasks which should have their device
> > permissions restricted.  Right now cgroups are all under kernel/.
> 
> No. Memory cgroup is under mm/ :)

Ah.

Guess it could all go under security/.  Should it still go there even if
we make it not use lsm?

> >> And to be honest, I didn't really look at it at all other than the
> >> diffstat to make sure you weren't messing with the kobj_map stuff
> >> anymore :)
> >>
> >> thanks,
> >>
> >> greg k-h
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
