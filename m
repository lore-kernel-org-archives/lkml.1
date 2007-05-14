Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXENTVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXENTVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXENTUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:20:55 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:12227 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbXENTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:20:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EP+aKnNpGC5mi0EtPqVECy+v3ZKoCwbxqFB2NoWJ4i7/g1WCtMxfPrCPvoWSlhG6v7JlaAth1BBEcO/YxF9skuX5QeYZMm0YeS9ZZkn82nfHbyoBImZVMX4cUdEErXpn/AhQv/7WdVbqlc4YbvUZp/da7lXJYXfROtW6LTxf4j4=
Message-ID: <4de7f8a60705141220j2764f326u69545490cdd23c08@mail.gmail.com>
Date: Mon, 14 May 2007 21:20:53 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [RFC][PATCH 14/14] tmpfs whiteout support
Cc: "Bharata B Rao" <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <Pine.LNX.4.64.0705141710280.29949@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094519.GP4139@in.ibm.com>
	 <Pine.LNX.4.64.0705141710280.29949@blonde.wat.veritas.com>
X-Google-Sender-Auth: 0cabe7ddf2834cf0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Hugh Dickins <hugh@veritas.com> wrote:
> On Mon, 14 May 2007, Bharata B Rao wrote:
> > From: Jan Blunck <j.blunck@tu-harburg.de>
> > Subject: tmpfs whiteout support
> >
> > Introduce whiteout support to tmpfs.
> >
> > Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> >  mm/shmem.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletion(-)
> >
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -74,7 +74,7 @@
> >  #define LATENCY_LIMIT         64
> >
> >  /* Pretend that each entry is of this size in directory's i_size */
> > -#define BOGO_DIRENT_SIZE 20
> > +#define BOGO_DIRENT_SIZE 1
>
> Why would that change be needed for whiteout support?
>

Good question. It seems that this a survivor of the changes necessary
for union readdir. This isn't necessary for white-outs.

BTW: Why do we claim this to be 20??? Is there any meaning behind this?

Cheers,
Jan
