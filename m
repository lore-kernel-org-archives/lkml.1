Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZDNN66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZDNN66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZDNNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:54:27 -0400
Received: from [212.69.161.110] ([212.69.161.110]:60300 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZDNNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:54:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 07/14] DRBD: internal_data_structures
Date: Tue, 14 Apr 2009 15:53:27 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com> <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com> <e2e108260904110018y74f39f1et39006ef9cd8f28d7@mail.gmail.com>
In-Reply-To: <e2e108260904110018y74f39f1et39006ef9cd8f28d7@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904141553.28542.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 April 2009 09:18:21 Bart Van Assche wrote:
> > +static inline void drbd_kobject_uevent(struct drbd_conf *mdev)
> > +{
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,10)
[...]
> There exist scripts which accept a kernel patch and a kernel version
> and remove all code that does not apply to the specified kernel
> version. Maybe it's a good idea to run the DRBD code through such a
> script before posting it for review.

Right, that was not intended for the LKML post. We are maintaining
it as out-of-tree module for our users. Sometimes it happens that this
compatibility cruft leaks into the for-linux branch.

Here are the changes triggered by your Friday and Saturday mails:
http://git.drbd.org/?p=linux-2.6-drbd.git;a=commit;h=b2a1682a0fd195f941a73e1ffb4e4198fe4c28ef

Probably it takes until tomorrow to answer the other mails...

Thanks!

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

