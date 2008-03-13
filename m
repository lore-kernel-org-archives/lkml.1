Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbYCMNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbYCMNwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYCMNwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:52:22 -0400
Received: from namei.org ([69.55.235.186]:39670 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907AbYCMNwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:52:21 -0400
Date: Fri, 14 Mar 2008 00:50:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Greg KH <greg@kroah.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
In-Reply-To: <20080313131818.GA9771@sergelap.austin.ibm.com>
Message-ID: <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
 <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au>
 <20080313131818.GA9771@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Serge E. Hallyn wrote:

> That does make for a simpler implementation at this point, however if
> any other such LSMs come along (as Casey seemed to think they would) the
> end result could end up being horrible spaghetti code of dependencies
> and interrelated configs.

That can be addressed as the need arises.  A basic tenet of kernel 
development is to avoid speculative infrastructure.

> But OTOH we went years with no such changes, so that's probably not a
> particularly practical concern unless someone can cite specific upcoming
> examples.  So if noone objects I'll try that approach.

-- 
James Morris
<jmorris@namei.org>
