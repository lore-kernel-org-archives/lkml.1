Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbYFIEv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbYFIEv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYFIEvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:51:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19407 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYFIEvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:51:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LCEpiY/LNn7DoVYSBFGkMmQHZdQlyalMqaNQr7F13l9M4h6D/pyLWSjhk2ti1Brhn
	8u18xk8VO0Cobc6kmXDlA==
Message-ID: <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
Date: Sun, 8 Jun 2008 21:51:09 -0700
From: "Grant Grundler" <grundler@google.com>
To: chris2553@googlemail.com
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       "Hannes Reinecke" <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200806061735.35268.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806010415.05290.chris2553@googlemail.com>
	 <200806060607.29460.chris2553@googlemail.com>
	 <1212761485.3466.6.camel@localhost.localdomain>
	 <200806061735.35268.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 10:35 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>...
> Yes, I still get the boot pause and the delay in desktop icons appearing when a
> usb-storage device is plugged in with -rc5. A boot log is attached. Is there
> some sort of verbose scsi boot messaging that I can switch on? I've looked but
> I'm damned if I can find anything in 'make menuconfig'.

SCSI_CONSTANTS and SCSI_LOGGING might help.
Both live in the SCSI options menu. Read the Kconfig help on how
to use SCSI_LOGGING.

Can you please also enable CONFIG_PRINTK_TIME ?

Using the timestamps in /var/log/messages is ok but not the most
reliable place to get somewhat accurate time stamps of events.

hth,
grant
