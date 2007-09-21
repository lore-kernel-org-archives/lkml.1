Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbXIUQEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbXIUQEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbXIUQEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:04:39 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:32149 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752307AbXIUQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:04:38 -0400
X-YMail-OSG: OYe5ZmoVM1lV36QhrtqdiOWUMY1.fdpxxzvBkQiGFo5he0W0sjLg.G76m1sv1.GyUGHwlVNZKg--
X-RocketYMMF: rancidfat
Date: Fri, 21 Sep 2007 09:04:37 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 00/22] Introduce credential record
To: David Howells <dhowells@redhat.com>, casey@schaufler-ca.com
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <9072.1190389216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <533105.53764.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> > > One thing I'm not certain about is how this should interact with /proc,
> > > which can display some of the stuff in the cred struct.  I think it may
> be
> > > necessary to have a real cred pointer and an effective cred pointer, with
> > > the contents of /proc coming from the real, but the effective governing
> > > what actually goes on.
> > 
> > I think you want the effective values to show up in /proc.
> 
> Perhaps - but bear in mind that in the override case they weren't set by the
> process itself.

They are nonetheless in effect and (heaven forbid) should they be
abused you don't want to hide the facts from concerned observers.


Casey Schaufler
casey@schaufler-ca.com
