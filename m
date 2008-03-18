Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYCRETk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYCRETk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYCRET3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:19:29 -0400
Received: from namei.org ([69.55.235.186]:57853 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751496AbYCRET3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:19:29 -0400
Date: Tue, 18 Mar 2008 15:17:53 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Pavel Emelianov <xemul@openvz.org>, Greg KH <greg@kroah.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] cgroups: implement device whitelist (v4)
In-Reply-To: <20080317180722.GA17111@sergelap.austin.ibm.com>
Message-ID: <Xine.LNX.4.64.0803181517260.1898@us.intercode.com.au>
References: <20080317180722.GA17111@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Serge E. Hallyn wrote:

> Implement a cgroup to track and enforce open and mknod restrictions on device
> files.  A device cgroup associates a device access whitelist with each
> cgroup.  A whitelist entry has 4 fields.  'type' is a (all), c (char), or
> b (block).  'all' means it applies to all types and all major and minor
> numbers.  Major and minor are either an integer or * for all.
> Access is a composition of r (read), w (write), and m (mknod).

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
