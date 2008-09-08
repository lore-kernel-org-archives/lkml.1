Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYIHWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYIHWcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYIHWcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:32:06 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62041 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYIHWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dGG0rSlFimtuqN5SGU9df0mYbKwtKwXlKGCBtkRtXac0ZYfm9sQk4M/99FAWjSOO09
         2gcsi7ZMTH5LRV4G0m5dKMQbPCc/QIqeDJ8kEdgox2DjzG0ly9v9hIM8Cir0WUI9m2nc
         l9RnWCqN0h/B1Axc9doZJ6fP7PE/pbxYZTr7o=
Message-ID: <86802c440809081532q1439342dheae1e1922dbb8670@mail.gmail.com>
Date: Mon, 8 Sep 2008 15:32:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <68676e00809081425r604baefaqd1ebb9502f5d9049@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
	 <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
	 <86802c440809081104i23b477e1w62bd5967b79529cb@mail.gmail.com>
	 <68676e00809081214h49eb07d4tb6145e8b47b00768@mail.gmail.com>
	 <86802c440809081235q57470134t51c61e2a6b97dc87@mail.gmail.com>
	 <68676e00809081300h2c835a44h3d55d0794852d75@mail.gmail.com>
	 <86802c440809081346i3fccea34u81f6b252b6c0c2a0@mail.gmail.com>
	 <68676e00809081425r604baefaqd1ebb9502f5d9049@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 2:25 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:

>>
>> so some config works, others not?
>
> Yes, that's correct, but it doesn't seem related to a particular
> configuration item (moon phase maybe).
> For example the kernel I'm using right now (-rc4-something) has the
> same config as a non-working kernel minus LOCKDEP, but git-current
> minus LOCKDEP does not work. On another kernel I got a working config
> just enabling DEBUG_INFO, in another case I disabled MTD.
>

do you mean tip/master?

http://people.redhat.com/mingo/tip.git/readme.txt

YH
