Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYE3SiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYE3SiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYE3SiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:38:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYE3SiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:38:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=MR4ld5AcTJvf4b6rm9OsSsFPk20Tf5QIpszYs6VUtV7E7Cd5ckMNlBdQIwUnNOuYx
	8Gh2zA2NY4toAgC96mPBg==
Message-ID: <da824cf30805301137q7ac83fby3844e07a7f969593@mail.gmail.com>
Date: Fri, 30 May 2008 11:37:50 -0700
From: "Grant Grundler" <grundler@google.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the kernel.
Cc: "David Miller" <davem@davemloft.net>,
       James.Bottomley@hansenpartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1212099060.18530.53.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212077700.26088.83.camel@shinybook.infradead.org>
	 <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com>
	 <20080529.140919.160813310.davem@davemloft.net>
	 <1212099060.18530.53.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 3:11 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Thu, 2008-05-29 at 14:09 -0700, David Miller wrote:
>> I've fought, like, forever, to
>> keep the tg3 driver with it's firmware in-tree.  I refuse to let the
>> driver get broken like that, it's staying working, and that means
>> in-tree and linked into the driver.
>
> Am I missing something here, or is the tg3 firmware contained in
> 'tg3FwText' and similar non-swappable u32 arrays which haven't changed
> _ever_ in our current git history?

It certainly has changed. Maybe that was before the move to git.
ISTR, Last time I looked at the tg3 firmware, it was on version 1.4 or 1.5.

thanks,
grant
