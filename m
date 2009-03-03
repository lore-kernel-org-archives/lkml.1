Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbZCCAYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbZCCAYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZCCAXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:23:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCCAXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:23:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aJhQBmaHYK7Zi3fOMLHHZ2CYNjFCO2b2qz4A9dkqtK5d+2lzmyfBryobuy7qnYvpK
	f+eXSh3V7DM43L/XBKJeA==
MIME-Version: 1.0
In-Reply-To: <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	 <6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
	 <20090303090950.60cea53a.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830903021615j6e1380e2l1544b67b187c1f5e@mail.gmail.com>
	 <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 2 Mar 2009 16:23:46 -0800
Message-ID: <6599ad830903021623q1666c519h5f68da7203b0f58a@mail.gmail.com>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 4:20 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> int mode;
>> if (cft->mode) {
>>   mode = cft->mode;
>> } else {
>>   if (cft->write_xxx || ....)
>>     mode |= 0600;
>>   if (cft->read_xxx || ...)
>>     mode |= 0444;
>> }
>>
> Oh, I see. But int mode=0, at first ;)

Oops, yes.

> I have no objections but please forgive subsys to set mode=0644 explicitly.

Do you mean "allow" rather than "forgive"? if so, then yes, a
subsystem should be able to override this to whatever it wants.

Paul
