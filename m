Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYAKQof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYAKQof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbYAKQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:44:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:17165 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbYAKQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u+HXTWGb3HHyrKDxivECMTAByRplSUz04Wm3sqcbkRVnozqxqRDyi5WaZ6Pnx4KfmNbUiM7adM6dLNdyKjEGPt/uA/sH+6wEmfnsIFvrETIcOy2VyXw40C5DcYrfqTp0pyO6nY6FNSkqjC/SwC4N8pwi8ib+k4Fk0oTAmYa22XU=
Message-ID: <9f00bd9d0801110844g176acdcdle0331783f82ed866@mail.gmail.com>
Date: Fri, 11 Jan 2008 18:44:23 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Cc: linux-scsi@vger.kernel.org, "Chuck Ebbert" <cebbert@redhat.com>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1200066295.3286.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
	 <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
	 <1200066295.3286.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 5:44 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> >
> > I havent reported "initio: I/O port range 0x0 is busy."
>
> Sorry ... we appear to have several reporters of different bugs in this
> thread.  That message was copied by Chuck Ebbert from a Red Hat
> bugzilla ... I was assuming it was the same problem.
>
> > I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.
>
> First off, has this driver ever worked for you in 2.6?  Just booting
> SLES9 (2.6.5) or RHEL4 (2.6.9) ... or one of their open equivalents to
> check a really old kernel would be helpful.  If you can get it to work,
> then we can proceed with a patch reversion regime based on the
> assumption that the problem is a recent commit.

Yes it works under 2.6.16.13.  See the beginning of this thread, i
mention there some things about newer versions.

>
> Thanks,
>
> James
>
>
>
