Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZIYPfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZIYPfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZIYPfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:35:38 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:34280 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZIYPfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LkE/eqjtUEdPDYigM+Lsvxtg/Az1UanMOf+mFdEEZhUakRrYnmloN/w8szwJ/+876B
         dWnPcSW9+rbx5zdxkUy7/jE+aRmXg5QwDClxZnzzw1wF0c/OVkut76QHLytNOYa9QDCi
         dtkX3mKsB6z5BYS2WZH5WSlXr5WkNT7hvfdJ8=
MIME-Version: 1.0
In-Reply-To: <20090925115636.5b4b8aca@linux.intel.com>
References: <b6a2187b0909240624u2821a312ub6d02df21d552248@mail.gmail.com>
	 <20090924160136.44e31ad0@lxorguk.ukuu.org.uk>
	 <b6a2187b0909240923t4e8d61f4g6d82b7f9f9bf621b@mail.gmail.com>
	 <20090925115636.5b4b8aca@linux.intel.com>
Date: Fri, 25 Sep 2009 23:35:41 +0800
Message-ID: <b6a2187b0909250835g1b72037er13b86bf762fd5e37@mail.gmail.com>
Subject: Re: linux-2.6.31 INIT: open(/dev/console): Input/output error (due to 
	commit b50989dc444599c8b21edc23536fc305f4e9b7d5)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 6:56 PM, Alan Cox <alan@linux.intel.com> wrote:
> From Andrew's tree:
>
>     tty: fix regression caused by "tty: make the kref destructor occur
>     asynchronously"
>
> which allows both a sync and an async element to the destruction
> cleanup. The console uses the synchronous one which avoids the delay
> before it becomes available again.

Alan,

Is this going into Linus's branch soon? Otherwise, please kindly post
the full patch so that I can test it instead of pulling 400MB from
Andrew's tree.

Thanks,
Jeff
