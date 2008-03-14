Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYCNQ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYCNQ7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYCNQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:59:42 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:55522 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbYCNQ7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:59:41 -0400
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
From: Stephen Smalley <sds@epoch.ncsc.mil>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20080314154537.GA6604@sergelap.austin.ibm.com>
References: <20080313131818.GA9771@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
	 <20080313143803.GA11265@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
	 <20080313224616.GA9139@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au>
	 <20080314014121.GA8320@sergelap.austin.ibm.com>
	 <20080314044741.GB18077@kroah.com>
	 <20080314135416.GD8744@sergelap.austin.ibm.com>
	 <47DA848C.3070901@openvz.org>
	 <20080314154537.GA6604@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 14 Mar 2008 12:57:58 -0400
Message-Id: <1205513878.22912.68.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 10:45 -0500, Serge E. Hallyn wrote:
> Quoting Pavel Emelyanov (xemul@openvz.org):
> > [snip]
> > 
> > >> My main question was why was that file in the kernel/ directory?
> > >> Shouldn't that also be in the security/ directory?
> > > 
> > > I'm using cgroups to track the tasks which should have their device
> > > permissions restricted.  Right now cgroups are all under kernel/.
> > 
> > No. Memory cgroup is under mm/ :)
> 
> Ah.
> 
> Guess it could all go under security/.  Should it still go there even if
> we make it not use lsm?

There is the precedent of the security/keys directory (security-related,
but not using LSM - aside from calling LSM hooks for access checks and
labeling of keys).

-- 
Stephen Smalley
National Security Agency

