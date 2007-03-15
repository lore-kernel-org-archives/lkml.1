Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXCONWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXCONWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933549AbXCONWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:22:31 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:13042 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544AbXCONWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/AkgvHcJlGeZGAiJKOC8A9oD8EzX4+MqAI7P2wdUiGxQRvIjkCj2/5NOknVnzSdLlVIYLZCDYun0gVZXxNXpM/Vg99G5L5isJnj2Qr5hyLFma+/2rlDxdqQ2yzCYfWgbw3jcvzlufn3osGNaxDRUuCyUY6/aJnAz7ZipMoqWGU=
Message-ID: <d120d5000703150622o43763828h5e01f313a3194f39@mail.gmail.com>
Date: Thu, 15 Mar 2007 09:22:25 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Oliver Neukum" <oneukum@suse.de>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Maneesh Soni" <maneesh@in.ibm.com>, gregkh@suse.de,
       "Richard Purdie" <rpurdie@rpsys.net>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703151402.08097.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070314194337.5d439dab@gondolin.boeblingen.de.ibm.com>
	 <20070315112725.7eadb7b7@gondolin.boeblingen.de.ibm.com>
	 <Pine.LNX.4.64.0703151219540.12584@blonde.wat.veritas.com>
	 <200703151402.08097.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Oliver Neukum <oneukum@suse.de> wrote:
> Am Donnerstag, 15. März 2007 13:31 schrieb Hugh Dickins:
> > Quite apart from this mysterious "other task", I don't understand
> > "access" either.
> >
> > Perhaps "defer" would best capture the idea of another-task and
> > maybe-delay? sysfs_defer_work(), struct sysfs_deferred_work?
>
> But we do not wish to defer or delay anything.
> How about: sysfs_action_from_neutral_context
>

How about sysfs_schedule_work? That is what it does - schedules a work
on a sysfs object and everyone here knows what schedule_work() does.

-- 
Dmitry
