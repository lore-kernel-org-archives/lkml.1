Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYLML4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYLML4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 06:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYLML4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 06:56:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:38619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYLML4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 06:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ow4C6zgmwaswRrgovDj2bJ0B+tZ/9rs5hdG2ttvsl0XlLky8FUK2HkmsmF/0/HEqdM
         TpXSFiojLnQ4d9MK91J+/QBvDtZJqcVQEysNDJjzbtfWQ2n+w72zPdb9buOjdfk/2IDq
         aPHt42slKCLx4T3Zi/7T6IFqKJ1/+4hUyTZg0=
Message-ID: <e2e108260812130356y1fe60713xf844a35c775e161d@mail.gmail.com>
Date: Sat, 13 Dec 2008 12:56:35 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Mike Christie" <michaelc@cs.wisc.edu>,
       "Hannes Reinecke" <hare@suse.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
	 <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
	 <1229167118.4153.930.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 12:18 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Of course I fix bugs when people report them.

Things have changed then since the beginning of this year. As anyone
can see in the threads I referred to, you have done your best to deny
that the crashes and system hangs were caused by LIO, although I had
posted exact instructions on how to reproduce the bugs. Regarding
kernel integration and subsystem maintainership: one of the important
tasks of a maintainer is to verify whether reported bugs are
reproducible, and if so, to resolve them. I'm happy none of the
current kernel maintainers has the habitude of denying bug reports
that are 100% reproducible and which contain exact instructions about
how to reproduce the bug.

> "Zero-copy means that data is copied as few times as possible".
>
> when I was attempting to explain the finer pointers of
> Target_Core_Mod/ConfigFS design to you and Vlad.  Remember that one..?
>
> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/8cff61671cd2de6b/37ade00e607dd8c8

You are going off topic -- the above statement has nothing to do with
this thread.

Regarding the statement itself: it's incorrect to quote that sentence
out of its context. In that thread, as anyone can see who looks up the
URL, I was using the word copies to refer to transfers between
hardware and RAM, not to copying data from RAM to RAM. Looking at that
statement now I agree that that was misleading, and that I should have
written that statement in another way.

Do you think people like it to discuss with you when you try to make
them appear ridiculous all the time ?

And what I do not understand is that you are playing games with the CC
list all of the time. It's considered impolite to leave out people
from a CC list unless someone asked explicitly to be left out.

Bart.
