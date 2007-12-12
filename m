Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXLLTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXLLTUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbXLLTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:20:44 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:48269 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754019AbXLLTUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:20:41 -0500
X-YMail-OSG: OkUb7JwVM1nHzSY_r2BNPgavx6YSkbxenHFliwU0cEj7yJlFSCk0UFyN8lSt1NK8uqE5SVFoPQ--
X-RocketYMMF: rancidfat
Date: Wed, 12 Dec 2007 11:20:40 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       Karl MacMillan <kmacmill@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <32137.1197483929@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <66139.71689.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > You may need to have an application, say cachefileselinuxcontext, that will
> > read the current policy and spit out an appropriate value of "<whatever>",
> > but that can be separate and LSM specific without mucking up your basic
> > infrastructure applications.
> 
> What would I do with such a thing?  How would it get run?  Spat out to where?

Put it in /etc/init.d/cachefiles and run it at boot time. Put the
result into /etc/cachefiles.conf. Have cachefilesd read it and pass
it downward.



Casey Schaufler
casey@schaufler-ca.com
