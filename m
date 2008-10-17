Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYJQTxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYJQTxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYJQTwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:52:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:27570 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbYJQTwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:52:54 -0400
Message-ID: <48F8ED0E.1060102@hp.com>
Date: Fri, 17 Oct 2008 15:52:46 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Steve French <smfrench@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: unlink behavior when file is open by
 other process
References: <524f69650810170809u2df1a309o2f357dc8489c06c6@mail.gmail.com>	<524f69650810170824x4f9ff975qb03d687c8d3557ff@mail.gmail.com>	<20081017132714.111e33f9@tleilax.poochiereds.net>	<524f69650810171041i57ab4466s8cecbdf0268f8417@mail.gmail.com> <20081017141013.3aecc88a@tleilax.poochiereds.net>
In-Reply-To: <20081017141013.3aecc88a@tleilax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:

> Sure, I'm not disputing whether returning an error on open is right or
> wrong. The problem is that it's not expected. We've just unlinked the
> filename and returned success -- there is *no* reason that the create
> should fail here. An application programmer will (rightfully) consider
> this a bug.

I agree that failing the unlink if you can not do it is
"the right thing to do"... but unless you have some magic
to prevent anyone else from creating the file between that
unlink and the create then in fact there is a reason the
application can see the create fail after unlink succeeds :)
