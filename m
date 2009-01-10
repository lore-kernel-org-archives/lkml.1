Return-Path: <linux-kernel-owner+w=401wt.eu-S932845AbZAJBdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbZAJBdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZAJBc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:32:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbZAJBc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:32:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=Tx7RF6xJ0wuoBHognmXuImXKMZ48Fa6md+/uJPd1pmziJIkoGgUSKerEhwyc4WgYG
	hXACS+YRJ7sILEgXKbeDA==
MIME-Version: 1.0
In-Reply-To: <20090109163725.11294fb1.akpm@linux-foundation.org>
References: <604427e00901051539x52ab85bcua94cd8036e5b619a@mail.gmail.com>
	 <604427e00901081840pa6dcc41u9a7a5c69302c7b60@mail.gmail.com>
	 <604427e00901091627n7c909abt6aa1f01c181ad65d@mail.gmail.com>
	 <20090109163725.11294fb1.akpm@linux-foundation.org>
Date: Fri, 9 Jan 2009 17:32:54 -0800
Message-ID: <604427e00901091732reaef7b5u6ccd89ffb840dbb8@mail.gmail.com>
Subject: Re: [PATCH]Fix: 32bit binary has 64bit address of stack vma
From: Ying Han <yinghan@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mikew@google.com,
       rohitseth@google.com, linux-api@vger.kernel.org, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.97
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 4:37 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 9 Jan 2009 16:27:07 -0800
> Ying Han <yinghan@google.com> wrote:
>
>> friendly ping...
>
> We'll get there.  We're in the merge window now, so I tend to defer
> non-serious bugfixes until things are a bit quieter.
Thank you Andrew .

>
>> On Thu, Jan 8, 2009 at 6:40 PM, Ying Han <yinghan@google.com> wrote:
>> > On Mon, Jan 5, 2009 at 3:39 PM, Ying Han <yinghan@google.com> wrote:
>> >> From: Ying Han <yinghan@google.com>
>> >>
>> >> Fix 32bit binary get 64bit stack vma offset.
>> >>
>> >> 32bit binary running on 64bit system, the /proc/pid/maps shows for the
>> >> vma represents stack get a 64bit adress:
>> >> ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]
>
> That changelog hurts my brain.
hm, i will change it for better reading.
>
>> >> Signed-off-by:  Ying Han <yinghan@google.com>
>
