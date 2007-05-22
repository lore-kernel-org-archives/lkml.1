Return-Path: <linux-kernel-owner+w=401wt.eu-S1764506AbXEVPBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764506AbXEVPBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbXEVPB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:01:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:13127 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbXEVPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HlL0GzQed1qBb9p42Jx7vVASWJj6t5CVvirXjwh39AphHCmySocqjng9x4mL2SM68HDYecP6LB8gJBn9KzeqAWJ1WY3Ts9zezPbJpkg4q6Fw8VzIwXqR7zjdxLjTCymwfCLi9HW5FnfvTykNtMh/Ren6JObjZjtm0xGmuGhOFtY=
Message-ID: <29495f1d0705220801v50e53f2dl24f9b198dd31c39c@mail.gmail.com>
Date: Tue, 22 May 2007 08:01:26 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Michael Halcrow" <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] eCryptfs: Delay writing 0's after llseek until write
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070522145124.GA3616@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070521230021.GD3621@us.ibm.com>
	 <20070521210708.67d365dc.akpm@linux-foundation.org>
	 <20070522145124.GA3616@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> On Mon, May 21, 2007 at 09:07:08PM -0700, Andrew Morton wrote:
> > On Mon, 21 May 2007 18:00:21 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> >
> > > Delay writing 0's out in eCryptfs after a seek past the end of the
> > > file until data is actually written.
> >
> > a) why?
>
> http://www.opengroup.org/onlinepubs/009695399/functions/lseek.html
>
> ``The lseek() function shall not, by itself, extend the size of a
> file.''
>
> > b) what is the impact upon a user of them not having this patch?
>
> Applications that lseek() past the end of the file without writing
> will experience unexpected behavior.

FWIW, I believe Andrew's point was that critical information for Joe
Enduser (and Joe Patch-Ho) was lacking in the original changelog.

Thanks,
Nish
