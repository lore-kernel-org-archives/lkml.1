Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYKQDS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYKQDS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbYKQDSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:18:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:58310 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbYKQDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QAgCFNbCKX1BXZxNoaPplyupn2VF3jyKVZ/nQo5REVXHx4hU7Ai3vq7FsmqohiGifB
         obSe8T2ieYNMoTQPsPTn+1ocAmMTAVZrWvN9EjXw8UpD9Wd6Hzg5hMYOUR4K7BjJA7db
         LcRjmLaFNM7lcFhYaSN7tj3CEKlay4hkSqamc=
Message-ID: <524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>
Date: Sun, 16 Nov 2008 21:18:43 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: third patch
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <20081115063641.26003498@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114185039.1f3af842@tleilax.poochiereds.net>
	 <524f69650811141609n63f3631bn6493e2be76b1bed6@mail.gmail.com>
	 <20081115063641.26003498@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff and I have worked on a series of patches to fix the oopses,
memory corruption and mount failures due to races in various linked
list handling relating to socket, session and tree connection when
using the reproducer detailed here:

https://bugzilla.samba.org/show_bug.cgi?id=5720

The fix series is now merged into cifs-2.6.git

Thanks to Jeff for great work.  It took quite a while to work through,
and I worked hard on an approach to make it smaller, but eventually we
decided that a larger fix was better.

On Sat, Nov 15, 2008 at 5:36 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri, 14 Nov 2008 18:09:33 -0600
> "Steve French" <smfrench@gmail.com> wrote:
>
>> I made a few minor cleanups to cifs_mount ... but have to run to my 7
>> year old's birthday dinner now.   If you have time, can you make sure
>> patch 3 still merges.
>>
>
> Ahh, the cleanup patch you were talking about didn't show up until I did a pull this morning for some reason. There were some deltas in your cleanup patch that made patch #3 not merge. Here's one that should.
>
> --
> Jeff Layton <jlayton@redhat.com>
>



-- 
Thanks,

Steve
