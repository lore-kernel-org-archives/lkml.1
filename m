Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZKJCTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZKJCTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZKJCTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:19:13 -0500
Received: from ozlabs.org ([203.10.76.45]:42542 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZKJCTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:19:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 10 Nov 2009 12:49:14 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization@linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <200911061740.03734.rusty@rustcorp.com.au> <20091109120839.GA11256@amit-x200.redhat.com>
In-Reply-To: <20091109120839.GA11256@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101249.14390.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 10:38:39 pm Amit Shah wrote:
> > 3) Don't use list_for_each_safe() to get the head entry of a list.  Your
> >    use is buggy anyway: buf will never be NULL afterwards.
> 
> As long as 'head' isn't the only node in the list we should loop. And
> list_foreach_safe() does that. So it's OK right?

If there's more than one, buf will be == head.

> I'm sorry for having created more work for you; I'll send out my patches
> to you in a couple of days.

I spent some time on the weekend creating patches.  They're not finished,
but they start the process of maturing the driver to where it can handle
multiple ports.

The next step is real buffer management (ie. the infrastructure for more than
one in flight, even though the normal console won't do this), then adding
headers.

I will post them now so you can take a look...
Rusty.
