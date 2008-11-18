Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYKRUXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYKRUXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYKRUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:23:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:55350 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbYKRUXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:23:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rk5rpppAFykX+N5DOw+etAHXPhKxdQ4FbYUbVW5ajo/S2Peqr/3mn/rGUGypCU8yqB
         AvtvuQ9we8zt/PtaTJ2eIaKMprmczO291ZBIfVsJbAX1ngYWpDZPzEoMmX6RxeabJO73
         9P2LBPGqUZVnS++Vr9aJiVEKyuh86TLEJcDhc=
Message-ID: <524f69650811181223s349300dcid686ed44f8af9715@mail.gmail.com>
Date: Tue, 18 Nov 2008 14:23:21 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: third patch
Cc: "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <20081117233833.GA28435@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114185039.1f3af842@tleilax.poochiereds.net>
	 <524f69650811141609n63f3631bn6493e2be76b1bed6@mail.gmail.com>
	 <20081115063641.26003498@tleilax.poochiereds.net>
	 <524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>
	 <20081117055603.GA1381@kroah.com>
	 <524f69650811171506y1f518c3bnac03e4f557ba29fb@mail.gmail.com>
	 <20081117233833.GA28435@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 5:38 PM, Greg KH <greg@kroah.com> wrote:
>> > On Sun, Nov 16, 2008 at 09:18:43PM -0600, Steve French wrote:
>> >> Jeff and I have worked on a series of patches to fix the oopses,
>> >> memory corruption and mount failures due to races in various linked
>> >> list handling relating to socket, session and tree connection when
>> >> using the reproducer detailed here:
>> >>
>> >> https://bugzilla.samba.org/show_bug.cgi?id=5720

> Well, if Linus takes them so late in the merge window, I'll consider
> also adding them to -stable, as they do fix reported problems, and are
> good to have in there for users who rely on cifs.
>
> thanks,
>
> greg k-h

Now merged into mainline



-- 
Thanks,

Steve
