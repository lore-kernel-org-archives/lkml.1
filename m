Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYGNXyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYGNXyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbYGNXx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:53:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:56471 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759903AbYGNXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hAEsTblmqjqMWkkNLDzp5KOG7xAclMz/eMmLQZbnRDLV700B+hHx8bqjJZdOg01VcP
         wG8Dfhob9/QEm0PM5mM6OodZ0aQV1Tp7EMmfDt1SyDeKrKIGaZYoyXwnSGqlFVfZmK1R
         FZKW8Z8PD64nOFArcZr3GSUqWBpUPHMOtxX+w=
Message-ID: <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
Date: Mon, 14 Jul 2008 16:53:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <1216079223.27455.92.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 4:47 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2008-07-14 at 16:41 -0700, Andrew Morton wrote:
>> On Mon, 14 Jul 2008 16:23:26 -0700
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>
>> > Linus, please pull from the for-2.6.27 branch of:
>> >     git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27
>>
>> The firmware flamewars seem to have subsided lately.  Is everyone happy
>> with this now?
>
> I've deliberately left drivers/net out of this pull request... all
> _other_ maintainers seemed quite happy to see their drivers updated to
> use request_firmware().
>
> Let's see how it pans out. I don't expect any problems -- after all,
> modern drivers have been using request_firmware() for a _long_ time now,
> and the distributions cope quite happily with it already. We're ready to
> ship the firmware in a separate package in Fedora as soon as Linus pulls
> from my tree. Once the dust has settled and it's all working fine, we
> can look at converting drivers/net and drivers/scsi too.

so after this patchset, if i put qllogic fw in firmware/, that fw will
work or not...

YH
