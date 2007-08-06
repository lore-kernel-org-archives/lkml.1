Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbXHFMtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbXHFMtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763947AbXHFMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:49:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49176 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbXHFMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:49:17 -0400
Date: Mon, 6 Aug 2007 07:49:14 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Kirill Korotaev <dev@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Andrey Savochkin <saw@sw.ru>,
       Adrian Bunk <bunk@stusta.de>, Cedric Le Goater <clg@fr.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: CLONE_NEWUTS documentation
Message-ID: <20070806124914.GB23642@sergelap.austin.ibm.com>
References: <46B599CA.9030302@gmx.net> <m1abt6kvym.fsf@ebiederm.dsl.xmission.com> <46B6C177.8040405@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6C177.8040405@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk-manpages@gmx.net):
> 
> 
> Eric W. Biederman wrote:
> > Michael Kerrisk <mtk-manpages@gmx.net> writes:
> > 
> >> Hello Serge,
> >>
> >> In 2.6.19, your patch to add support for CLONE_NEWUTS was included.  Is
> >> there there some for-userland-programmers documentation of this flag
> >> somewhere?  Would you be able to send some documentation to me (ideally as
> >> a patch to the clone.2 man page, but otherwise some plain text will do).
> >>
> >> If this flag is also supported for unshare(), then could you please send me
> >> a patch/text for that too?
> > 
> > Again a short summary
> > 
> > The utsname namespace encapsulates the global kernel identification stored
> > in struct utsname returned from uname(2).
> > 
> > It is a very trivial namespace but it allows you to set multiple hostnames
> > and nis domainnames on the same machine.
> 
> Thanks Eric.
> 
> And a further question: is CLONE_NEWUTS implemented for unshare()?

Yes, it is.  And unlike CLONE_FS but like CONE_NEWNS, it has the same
meaning for unshare as for clone.

thanks,
-serge
