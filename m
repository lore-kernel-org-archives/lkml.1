Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbYHUOzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbYHUOzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYHUOzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:55:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64286 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYHUOzf (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VPBC87HPsxp0KieHtMyStFlqH1MXzYnr5Ary2/xYVRyYFnl5lR9d+Z4pQfaT3qSBGU
         /sDZl5UhN9KAI5iY5DmLXs1kV/WUouEmO2qx+SLX/eA1nd8EptZUmqk1zP8Pxxb2PI6m
         G1W/frki2xFadCLM8JhKGxrc2KglxFARu8LUo=
Message-ID: <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:55:34 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Cc: "David Woodhouse" <dwmw2@infradead.org>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       nickpiggin@yahoo.com.au
In-Reply-To: <200808211339.37187.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F8.1030004@gmail.com> <48AD2AFF.5060609@de.ibm.com>
	 <1219308560.2988.247.camel@pmac.infradead.org>
	 <200808211339.37187.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 4:39 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 August 2008, David Woodhouse wrote:
>> On Thu, 2008-08-21 at 10:44 +0200, Carsten Otte wrote:
>> >
>> > Exporting profiling data for a file system in another file system
>> > (/proc) seems not very straigtforward to me. I think it is worth
>> > considering to export this information via the same mount point.
>>
>> I would have said sysfs, rather than 'the same mount point'.
>>
>
> Let me throw in debugfs as my preferred option. sysfs is for stable
> interfaces, while profiling generally fits into the debugging category.

Three responses, three suggestions....

1) same mount point -
I don't see how this works without an ioctl.  I can't just make up
files in my mounted filesystem.   You expect the mounted version to
match input to the mkfs.  I'd not be happy with an ioctl.  You can
just read it.

2) sysfs -
I agree with Carsten, I don't see how this fits in the sysfs hierarchy.

3) debugfs -
I don't know diddly about this.

So why not /proc?
