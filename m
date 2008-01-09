Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYAIS4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYAIS4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYAIS4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:56:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYAIS4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:56:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil>
References: <1199902278.9393.283.camel@moss-spartans.epoch.ncsc.mil> <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil> <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil> <20071205193818.24617.79771.stgit@warthog.procyon.org.uk> <20071205193859.24617.36392.stgit@warthog.procyon.org.uk> <25037.1197306473@redhat.com> <17868.1199897484@redhat.com> 
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 09 Jan 2008 18:56:20 +0000
Message-ID: <1316.1199904980@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> Right, the latter is reasonable.
> Requires adding the class and permission definition to
> policy/flask/security_classes and policy/flask/access_vectors and then
> regenerating the kernel headers from those files, ala:
>   svn co http://oss.tresys.com/repos/refpolicy/trunk refpolicy
>   cd refpolicy/policy/flask
>   vi security_classes access_vectors
>   <add new class to end>
>   make
>   make LINUX_D=/path/to/linux-2.6 tokern

Does this require rebuilding and updating all the SELinux rpms to know about
the new class?

David
