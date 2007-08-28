Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXH1NJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXH1NJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXH1NIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:08:51 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:33238 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXH1NIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M6uWJRSetyyXJpxbSkiV05wjODdPOZzmlvsH6LsqxdK1GyX3DYqwnErdlyw9KMwn+WRAscWh+bAFjwXnwve5syIS55sa/zFRQP1BJStCrz7tijfDwi/lDB3WpHUe7sSDr67YGufWZ3HLRM6+gAD1xNSQEfft0XLm1uTLFiwwuPU=
Message-ID: <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>
Date: Tue, 28 Aug 2007 06:08:45 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Cc: "Michael J. Evans" <mjevans1983@comcast.net>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46D3A8AD.6000701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <200708271516.21889.mjevans1983@comcast.net>
	 <20070827153020.43788e21.randy.dunlap@oracle.com>
	 <200708272138.19785.mjevans1983@comcast.net>
	 <46D3A8AD.6000701@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Michael J. Evans wrote:
> > On Monday 27 August 2007, Randy Dunlap wrote:
> >> On Mon, 27 Aug 2007 15:16:21 -0700 Michael J. Evans wrote:
> >>
> >>> =============================================================
> >>> --- linux/drivers/md/md.c.orig      2007-08-21 03:19:42.511576248 -0700
> >>> +++ linux/drivers/md/md.c   2007-08-21 04:30:09.775525710 -0700
> >>> @@ -24,4 +24,6 @@
> >>>
> >>> +   - autodetect dev list not array: Michael J. Evans
> > <mjevans1983@gmail.com>
> >>> +
> >> Nowadays we use an SCM for such comments, not the source file(s).
> >
> > SCM?  Is this automatic, where do I go to see it?
>
> See Documentation/SubmittingPatches:
> 14) The canonical patch format:
>
> The canonical patch message body contains the following:
>
>   - A "from" line specifying the patch author.
>
>   - An empty line.
>
>   - The body of the explanation, which will be copied to the
>     permanent changelog to describe this patch.
>
>   - The "Signed-off-by:" lines, described above, which will
>     also go in the changelog.
>
>   - A marker line containing simply "---".
>
>   - Any additional comments not suitable for the changelog.
>
>   - The actual patch (diff output).
>
>
> so just put whatever you want to be in the permanent SCM logs
> into the "body of the explanation" part of the email.
>
>
> --
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

Oh, I see.  I forgot about the changelogs.  I'd send out version 5
now, but I'm not sure what kernel version to make the patch against.
2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
Additionally I never could tell what git tree was the 'mainline' as it
isn't labeled with such a keyword (at least in the list of git trees I
saw).
