Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYDAMfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYDAMfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 08:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYDAMfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 08:35:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:53064 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbYDAMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nbQ7T+cpzpo+ROhsjq4OMz9Bv8JkUEjb1JDl+XHJc2OC0IxO6PGCRFe6dzjDFa9yAEUdDR8c1UZgZa8vTsL/IVp+9Xeq2Gc8SgudZKAlNiBBGEj2sSSlIW/py/AXHCc4LfBPKZ4pOAgizcjOWyMoHA59SFW6unjVlayakY0qK9M=
Message-ID: <b6fcc0a0804010534w729c277cr76294b13aeb69080@mail.gmail.com>
Date: Tue, 1 Apr 2008 15:34:58 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       daniel@hozac.com, lizf@cn.fujitsu.com,
       "Pavel Emelyanov" <xemul@openvz.org>, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20080401123218.GE12129@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326180543.GA27709@sergelap.austin.ibm.com>
	 <20080329081839.GA4423@ucw.cz>
	 <20080331140053.GA9909@sergelap.austin.ibm.com>
	 <20080401123218.GE12129@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/08, Pavel Machek <pavel@ucw.cz> wrote:
> > > > --- a/include/linux/cgroup_subsys.h
> > > > +++ b/include/linux/cgroup_subsys.h
> > > > @@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
> > > > #endif
> > > >
> > > > /* */
> > > > +
> > > > +#ifdef CONFIG_CGROUP_DEVICE
> > > > +SUBSYS(devices)
> > > > +#endif
> > > > +
> > > > +/* */
> > >
> > > I don't know what this is, but it does not look like C...
> >
> > Huh?
>
> Empty comments as separators?

They help when multiple people add such SUBSYS things and
do not have to fight rejects.
