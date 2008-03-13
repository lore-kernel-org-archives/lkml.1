Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYCMW2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYCMW2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYCMW15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:27:57 -0400
Received: from namei.org ([69.55.235.186]:52925 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbYCMW14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:27:56 -0400
Date: Fri, 14 Mar 2008 09:27:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Greg KH <greg@kroah.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
In-Reply-To: <20080313143803.GA11265@sergelap.austin.ibm.com>
Message-ID: <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
 <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au>
 <20080313131818.GA9771@sergelap.austin.ibm.com>
 <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
 <20080313143803.GA11265@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Serge E. Hallyn wrote:

> True, but while this change simplifies the code a bit, the semantics
> seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
> and:
> 
> 	SECURITY=n or
> 	rootplug is enabled
> 	capabilities is enabled
> 	smack is enabled
> 	selinux+capabilities is enabled

Well, this is how real systems are going to be deployed.

It becomes confusing, IMHO, if you have to change which secondary LSM you 
stack with SELinux to enable a cgroup feature.

-- 
James Morris
<jmorris@namei.org>
