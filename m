Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYJ1WDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYJ1WDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 18:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbYJ1WDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 18:03:30 -0400
Received: from mail.crca.org.au ([67.207.131.56]:33578 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbYJ1WD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 18:03:29 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
	 <1225229399.9661.13.camel@nigel-laptop>
	 <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 29 Oct 2008 09:03:25 +1100
Message-Id: <1225231405.9661.18.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2008-10-28 at 22:51 +0100, Miklos Szeredi wrote:
> On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > However it does not fix the freezing of tasks which are waiting for
> > > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > > This is the tricky part...
> > 
> > Convert them all to wait_event_freezeable.
> 
> You mean convert mutexes to event queues?  Not a very good idea.

No, I don't. Sorry. I was thinking you were referring to the wait_event
calls in the fuse request code. My bad.

Perhaps it's best to go back to my original position: hold new requests
and allow existing ones to complete. I'll look again at previous
messages to see why you thought that was problematic.

Regards,

Nigel

