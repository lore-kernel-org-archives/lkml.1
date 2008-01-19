Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYASOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYASOVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYASOVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:21:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:11807 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYASOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PaD1UKmdbItJjwP/Lfl0hpFWo/eZREMjjnN72FwoHkKi5IqNcrR+0q1kuVom3rpLEMvnBVfqYSqfWVoYKtxWNbpDSEyL5TwC+Ce1QL+mCSBpZE0lv5Eb83lAbRm+ORP3fEA66p4Whe0ahuYif+Qsvbd8NXio3VwA3X5Cff8EeQQ=
Message-ID: <ee3dc96c0801190621p1970086fj218178a7519fe4af@mail.gmail.com>
Date: Sat, 19 Jan 2008 11:21:11 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Rafael Sisto" <rafael.sisto@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
In-Reply-To: <20080119134837.GA15610@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
	 <20080119134837.GA15610@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnaldo, I didnt see your mail before.
I read some of the code you suggested, but it seems so complicated! I
just need to create a file named "file" on the path /tmp/.. Isn't
there an easier way?

Or else, where can I find some more information about what the parameters mean?
(struct svc_rqst *rqstp, struct nfsd3_createargs *argp, struct
nfsd3_diropres   *resp)
It seems that with the "argp" parameter, I could pass all my
information, but I dont see what to put on the other parameters...

I would greatfuly thank some link where to find some information, please.
greetings,
Rafael Sisto.


On Jan 19, 2008 10:48 AM, Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> Em Sat, Jan 19, 2008 at 10:42:40AM -0300, Rafael Sisto escreveu:
> > Dear forum,
> > can anybody help me with this issue?
> >
> > How do I create a new file in kernel mode?
> > I am trying to create a file in a system call I am building.
>
> Look at how NFS does.
>
> fs/nfsd/nfs3proc.c
> nfsd3_proc_create
>
> - Arnaldo
>
