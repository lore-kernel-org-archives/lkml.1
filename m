Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYLEG3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYLEG3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 01:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYLEG25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 01:28:57 -0500
Received: from kandzendo.ru ([195.178.208.66]:54365 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYLEG25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 01:28:57 -0500
Date: Fri, 5 Dec 2008 09:28:54 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [W1] Updated documentation.
Message-ID: <20081205062854.GA24227@ioremap.net>
References: <12284022104086-git-send-email-zbr@ioremap.net> <122840221468-git-send-email-zbr@ioremap.net> <12284022143564-git-send-email-zbr@ioremap.net> <12284022144105-git-send-email-zbr@ioremap.net> <12284022141659-git-send-email-zbr@ioremap.net> <49386D75.2030302@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49386D75.2030302@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy.

On Thu, Dec 04, 2008 at 03:53:25PM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > --- a/Documentation/w1/w1.netlink
> > +++ b/Documentation/w1/w1.netlink
> > @@ -17,25 +17,27 @@ Protocol.
> >  [struct cn_msg] - connector header. It's length field is equal to size of the attached data.
> 
> (not in this patch, but:)              Its

Yup :)
 
> > -Each connector message can include one or more w1_netlink_msg with zero of more attached w1_netlink_cmd messages.
> > +Each connector message can include one or more w1_netlink_msg with zero or more attached w1_netlink_cmd messages.
> 
> Please limit lines to a maximum of 80 characters.  Around 72 would be Good.
> (here and elsewhere)

Will change.

> >  For event messages there are no w1_netlink_cmd embedded structures, only connector header
> >  and w1_netlink_msg strucutre with "len" field being zero and filled type (one of event types)
> 
>                       structure
 
> > +	cn_msg (CN_W1_IDX.CN_W1_VAL as id, len is equal to sizeof(struct
> > +	w1_netlink_msg) plus number of masters multipled by 4)
> 
> 	                                       multiplied

Changed.

> > @@ -82,10 +98,10 @@ Connector [1] specific documentation.
> >  Each connector message includes two u32 fields as "address".
> >  w1 uses CN_W1_IDX and CN_W1_VAL defined in include/linux/connector.h header.
> 
>       uses them for what?

They define destination address in connector subsystem.

> >  Each message also includes sequence and acknowledge numbers.
> > -Sequence number for event messages is appropriate bus master sequence number increased with
> > +Sequence number for event messages is appropriate bus master sequence number increased with 
> 
> Line ends with space.  Please check for that throughout the file.

Ok.

> > @@ -93,6 +109,6 @@ Additional documantion, source code examples.
> 
>                                 documentation

Changed

> I'll plan to review the entire doc file.

Great, thank you!
I will roll out updated version today with this changes and fixed patch
mentioned by Frederik.

-- 
	Evgeniy Polyakov
