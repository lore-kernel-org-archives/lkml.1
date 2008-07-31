Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYGaTqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYGaTqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbYGaTqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:46:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:43517 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYGaTqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i/k3SFYF7S1rZniPDT5tqCSpuolhwLy1nuIK2/3RrvVJM9FFafpd5TbOj7bhoquwm2
         NMJVXvw5Bq2qM6KtogTTm8ynqHWWFzFOUNvLNhAc6MhLPoIXogxtVRktaYx16fz6MOhw
         N8+4cE+IedDlU4Mp4LTXQvsGvneliefRcYzSA=
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features
From: Josh Boyer <jwboyer@gmail.com>
To: Ulrich Teichert <krypton@ulrich-teichert.org>
Cc: Tim Bird <tim.bird@am.sony.com>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, torvalds@linux-foundation.org,
       thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com
In-Reply-To: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org>
References: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 15:46:28 -0400
Message-Id: <1217533588.2328.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 20:50 +0200, Ulrich Teichert wrote:
> Hi,
> 
> >I don't know of any embedded products that ship with NTP turned
> >on.
> 
> Well, I do. To be exact, I've developed parts of it. But it's numbers
> are only into the thousands, so that makes it insignificant ;-)
> 
> >It's best to assume, with embedded, that we're not shipping
> >ANY of the desktop or server applications you are familiar with.
> >Absent those, does something break in the kernel with multicast
> >support when IGMP is turned off?
> 
> I do not think of NTP as desktop or server application, but that's
> probably just me,

No, it's not just you.  NTP is useful in cases where things do care
about time but hardware designers were too cheap to put an RTC on the
board.

I will admit that it's use in embedded products is probably very limited
though.

josh

