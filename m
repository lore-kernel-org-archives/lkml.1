Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYCMWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYCMWqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYCMWqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:46:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52155 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYCMWqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:46:21 -0400
Date: Thu, 13 Mar 2008 17:46:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080313224616.GA9139@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> 
> > True, but while this change simplifies the code a bit, the semantics
> > seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
> > and:
> > 
> > 	SECURITY=n or
> > 	rootplug is enabled
> > 	capabilities is enabled
> > 	smack is enabled
> > 	selinux+capabilities is enabled
> 
> Well, this is how real systems are going to be deployed.

Sorry, do you mean with capabilities?

> It becomes confusing, IMHO, if you have to change which secondary LSM you 
> stack with SELinux to enable a cgroup feature.

So you're saying selinux without capabilities should still be able to
use dev_cgroup?  (Just making sure I understand right)

-serge
