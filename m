Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXHISwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXHISwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXHISv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:51:59 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:35856 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753106AbXHISv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:51:58 -0400
X-YMail-OSG: KriZo4oVM1nosRTjxF6iZ3p873LsmIRrjO.Moh9kKmTTuB8FgFF9aih7vFfK4PHhP.je4k_oFg--
X-RocketYMMF: rancidfat
Date: Thu, 9 Aug 2007 11:51:56 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 09/14] CacheFiles: Permit a process's create SID to be overridden [try #2]
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20954.1186682862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <763414.38514.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > This is SELinux specific funtionality and should be done in the
> > SELinux code. You should not be adding interfaces that are SELinux
> > specific, in this case using secids instead of the LSM blob interfaces.
> 
> Is using secids your only objection?  Or are you objecting to the whole
> 'act-as' concept?

My knee jerk reaction is that that is likely to be SELinux specific
behavior as well. I'm going to have to look at the patch more carefully
before I can say for sure. I will try to make a constructive proposal
once I've had the chance to think on it a little. Sorry about the terse
and unhelpful initial reaction.


Casey Schaufler
casey@schaufler-ca.com
