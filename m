Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZDPPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZDPPdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZDPPdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:33:22 -0400
Received: from [212.69.161.110] ([212.69.161.110]:48159 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbZDPPdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:33:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 05/14] DRBD: request
Date: Thu, 16 Apr 2009 17:32:23 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com> <e2e108260904160006g359b11aj2714a3df2dfe7bdb@mail.gmail.com>
In-Reply-To: <e2e108260904160006g359b11aj2714a3df2dfe7bdb@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904161732.24321.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 April 2009 09:06:49 Bart Van Assche wrote:
> On Fri, Apr 10, 2009 at 2:12 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > + * See also documentation/drbd-request-state-overview.dot
> > + *  (dot -Tps2 documentation/drbd-request-state-overview.dot | display
> > -)
>
> Hello Philipp,
>
> Where can the file drbd-request-state-overview.dot be found ? It's
> neither included in this patch series nor in drbd-8.3.1.tar.gz.
>
> As far as I know documentation for new kernel components should be
> included in the kernel patch itself as a new file under the
> Documentation directory.
>

Hi Bart,

That is unfortunately an other outdated comment. I will remove it. 
I can not find that file either. 

But, when we are at it, there are some files that probably fall
into this category. Some diagrams about the main state engine
.dot files, Two diagrams showing an overview how the packets
on the wire are used.

Those are too specific that they where never published as a part
of one of the papers, but they provide valuable information for 
someone who wants to work on the DRBD code.

I have put it into git...
http://git.drbd.org/?p=linux-2.6-drbd.git;a=commit;h=220212f3be921da5ce275e7b4f874490c22236f0

it will be included in future incarnations of the patch set.

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

