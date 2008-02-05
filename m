Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYBEBRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYBEBRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYBEBPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:50 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:46552 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758269AbYBEBPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:48 -0500
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Date: Tue, 5 Feb 2008 03:15:59 +0200
User-Agent: KMail/1.9.8
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org
References: <47A2D439.9050704@kernel.org> <47A6661D.7020305@kernel.org> <20080204164524.GC20130@sergelap.ibm.com>
In-Reply-To: <20080204164524.GC20130@sergelap.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050315.59476.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Monday 04 February 2008 around 18:45:24 Serge E. Hallyn wrote:
> Quoting Andrew G. Morgan (morgan@kernel.org):
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Ismail D??nmez wrote:
> > | What I meant to ask was what does "per-process securebits" brings as
> >
> > extra.
> >
> > It allows you to create a legacy free process tree. For example, a
> > chroot, or container (which Serge can obviously explain in more detail),
>
> (Just to give my thoughts on securebits and containers)
>
> A container is a set of processes which has its own private namespaces
> for all or most resources - for instance it sees only processes in its
> own pid namespace, and its first process, which is sees as pid 1, is
> known as some other pid, maybe 3459, to the rest of the system.
>
> We tend to talk about 'system containers' versus 'application
> containers'.  A system container would be like a vserver or openvz
> instance, something which looks like a separate machine.  I was
> going to say I don't imagine per-process securebits being useful
> there, but actually since a system container doesn't need to do any
> hardware setup it actually might be a much easier start for a full
> SECURE_NOROOT distro than a real machine.  Heck, on a real machine init
> and a few legacy deamons could run in the init namespace, while users
> log in and apache etc run in a SECURE_NOROOT container.
>
> But I especially like the thought of for instance postfix running in a
> carefully crafted application container (with its own virtual network
> card and limited file tree and no visibility of other processes) with
> SECURE_NOROOT on.

This is really interesting security wise, will be nice to see how it can be 
implemented in real life.

Thanks for the explanation and the implementation ;-)

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
