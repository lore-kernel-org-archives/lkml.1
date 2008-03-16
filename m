Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYCPA7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYCPA7U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 20:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbYCPA7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 20:59:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10411 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYCPA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 20:59:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QFxBE6PoDSqZRcJO52RoBb48M2miVdfnMyU6SkQtx5Ff0f+SoOLz9NpWmfWBcdMPV
	iJ7LDPUYL9C+UA2cEHQ5A==
Message-ID: <6599ad830803151759w27d0a5cfgbfa9fab54c224751@mail.gmail.com>
Date: Sun, 16 Mar 2008 08:59:06 +0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Cc: "Pavel Emelyanov" <xemul@openvz.org>, "James Morris" <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       "Stephen Smalley" <sds@epoch.ncsc.mil>,
       "Casey Schaufler" <casey@schaufler-ca.com>
In-Reply-To: <20080314144209.GF9741@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080313131818.GA9771@sergelap.austin.ibm.com>
	 <20080313143803.GA11265@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au>
	 <20080313224616.GA9139@sergelap.austin.ibm.com>
	 <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au>
	 <20080314014121.GA8320@sergelap.austin.ibm.com>
	 <47DA4533.8030106@openvz.org>
	 <20080314135817.GE8744@sergelap.austin.ibm.com>
	 <6599ad830803140712i1f9dede3yb0be99528934d974@mail.gmail.com>
	 <20080314144209.GF9741@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 10:42 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>  cgroup hooks next to the lsm hooks.  So in fs/namei.c where there are
>  security_inode_permission() hooks, there would also be
>  cgroup_inode_permission() hooks to let the devices cgroup mediate the
>  access.  Well, in permission(), probably not in exec_permission_lite()
>  since that's probalby not a device access  :)

This would just be a device cgroup-specific thing, right? Nothing to
do with the generic framework? If so, then that sounds fine (to me, at
least).

Paul
