Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXDBNqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXDBNqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 09:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965456AbXDBNqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 09:46:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:54600 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965458AbXDBNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 09:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qXRAYmE8cLC7XErBjof6EnMBK4ftWuaHDYyavw+PZbZ0CpYj1JStFLScR/PIKtqe0Onj1/7C3XvQ/tLZp75ocKZe96n9p79L/C2qIPbs593+JoNH7J5Ko60GCjOy29sowxAF9ypUblI+SWP0OCn0bXxiu8Zcd2yKnveWJBVLTOM=
Message-ID: <d120d5000704020646m6d8a14c9te6c69ff8b57fd79e@mail.gmail.com>
Date: Mon, 2 Apr 2007 09:46:08 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dan Engel" <dan@sourceharvest.com>
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1175520828.12355.84.camel@monica.engel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175396188.7857.15.camel@monica.engel.home>
	 <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
	 <1175484539.12355.18.camel@monica.engel.home>
	 <200704020004.51861.dtor@insightbb.com>
	 <1175508842.12355.34.camel@monica.engel.home>
	 <d120d5000704020606y620df4bfu1cf3728070f02a38@mail.gmail.com>
	 <1175520828.12355.84.camel@monica.engel.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/07, Dan Engel <dan@sourceharvest.com> wrote:
>
> On a side note, I'm not sure why those input key events are there. The
> basic idea of the device is that you can switch KVM control back and
> forth, while keeping audio on a single computer (e.g., to listen to
> music), and at first I thought those key events were to feed audio
> controls through from the computer with KVM focus to the one with audio
> focus, so that if you're working on either computer you can adjust the
> volume, etc. However, the computer that does not have KVM focus will
> never receive these events, since switching KVM focus effectively
> disconnects the device completely from the computer.
>

* Pulled out of my behind idea *
It could be that the KVM allows you to limit or normalize volume
coming out of your speakers so that you don't get blasted with full
sound if switch from one box to another.

-- 
Dmitry
