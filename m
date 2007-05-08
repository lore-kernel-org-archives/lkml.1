Return-Path: <linux-kernel-owner+w=401wt.eu-S968181AbXEHO1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968181AbXEHO1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968169AbXEHO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:27:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:12401 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968107AbXEHO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Mllso8DX/5O/icVFVi2C8uPviMx6oEo+llDaWKFD2V6aSEbUHh5DnFqtsh9sxd49jc8LzPH1vwjpw+swBdq48JkVf+JQVK6Y+XzoxgXD0/ASP2vh7HwDmQkZ/TFSmsE2FzCSeXPZGINyC8Qc3oKQpsE3NDOEwnXsERGVCryjO34=
Message-ID: <84144f020705080727o44ae55f9pfb20cf653223aa0f@mail.gmail.com>
Date: Tue, 8 May 2007 17:27:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: New Mitsumi legacy CD-ROM driver
Cc: "Andrew Morton" <akpm@osdl.org>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464045F0.3040906@gmail.com>
	 <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
X-Google-Sender-Auth: 5513508f22e11732
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Rene Herman <rene.herman@gmail.com> wrote:
> > +static int __mitsumi_read_toc(struct mitsumi_cdrom *mcd)
> > +{
> > +       int tracks = mcd->header.cdth_trk1 - mcd->header.cdth_trk0 + 1;
> > +       int retries;
> > +       int err = 0;
> > +
> > +       kfree(mcd->toc);
> > +
> > +       mcd->toc = kzalloc(tracks * sizeof *mcd->toc, GFP_KERNEL);

On 5/8/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Perhaps we should use krealloc() + memset() here?

Strike that, krealloc() only makes it look ugly.
