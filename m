Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYEaDlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYEaDlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 23:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYEaDlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 23:41:31 -0400
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:32623 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750801AbYEaDla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 23:41:30 -0400
X-YMail-OSG: t63ljuEVM1lIHnHV2GnYiHg7FtMd.OlQz4MRbWJ8n4YqusQFuqDpea4nigPy0AJpICpcTBpJne63LRhbzNGmC4vd.UDCd3kQHbIGUBDRFIZmc7O9xwKRAqKrwUo-
X-RocketYMMF: rancidfat
Date: Fri, 30 May 2008 20:41:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
To: Miklos Szeredi <miklos@szeredi.hu>, lcapitulino@mandriva.com.br
Cc: casey@schaufler-ca.com, miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-Reply-To: <E1K1l3b-0008Rx-4i@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <848198.48297.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Miklos Szeredi <miklos@szeredi.hu> wrote:

> >  I'm not sure whether this is a smack problem, but Mandriva users are
> > reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
> > they try to mount their NTFS partition.
> 
> Yes, this is a smack/fuse interaction problem.  Also see this thread:
> 
>   http://marc.info/?l=fuse-devel&m=120931855107469&w=2
> 
> Casey, you were CC-d on the last mail in that thread.  Did you miss
> that?

Ok. I just set my a machine to try this on and with today's
Linus git tree as the base I'm able to mount an NTFS file system
just fine. Just to be perverse, the machine I'm working with
has Oracle Enterprize 5 installed, with ntfsprogs-2.0.0. 

How about a .config, lsmod, etc?

Thank you.


Casey Schaufler
casey@schaufler-ca.com
