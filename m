Return-Path: <linux-kernel-owner+w=401wt.eu-S932218AbYEFSl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbYEFSl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbYEFSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:41:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:38173 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbYEFSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l7hcevm93ZM4VFGgJgqz6p+9SIuksE3cOiFEx9JGiAsA/7ygj2ASmejbXJghBUbXFc6Iy1hBrtL2HyPus6Y/+I5pN0GCnsjj44cJUG+MoP9OahsYzcmvawzbOCOuyOAtDZRNCdS795uPBov2ay6qmZkkfwrZiJ2y1mImy9n4W1M=
Message-ID: <939d53060805061141g3803a380j50ca89f39dbf0fe6@mail.gmail.com>
Date: Tue, 6 May 2008 20:41:33 +0200
From: "Benjamin Thery" <ben.thery@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [RESEND][PATCH 00/11] sysfs tagged directories
Cc: "Benjamin Thery" <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Tejun Heo" <htejun@gmail.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Daniel Lezcano" <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Pavel Emelyanov" <xemul@openvz.org>, netdev@vger.kernel.org
In-Reply-To: <20080506175331.GA1815@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506173030.653828076@theryb.frec.bull.fr>
	 <20080506175331.GA1815@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 7:53 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, May 06, 2008 at 07:30:30PM +0200, Benjamin Thery wrote:
>  > This is still the same port of Eric Biederman's patchset to implement
>  > tagged directories in sysfs that was discussed a few days ago.
>  >
>  > This time it applies on top of 2.6.26-rc1,
>  > which includes a fix from Daniel Lezcano to fix net device renaming
>  > for sysfs (and of course all the network namespaces stuff that was
>  > committed in net-2.6.26).
>  >
>  > This patchset still contains the patch from Serge Hallyn that implements
>  > tagging for user namespaces.
>  >
>  > It also contains a patch from Daniel Lezcano which allows to have net
>  > devices with the same name in two different network namespaces.
>
>  Does this all work properly with both CONFIG_SYSFS_DEPRECATED enabled
>  and disabled?

Yes.
I tested both cases and with my limited knowledge of sysfs (I'm mostly
interested in /sys/class/net population), this looked fine to me.

>
>  Can you show some outputs of 'tree' in both cases on the /sys/class/net/
>  directory?

Sure.
I hope you don't mind if I'll send them tomorrow I'm back home right now
and have limited access to my test machines.

-benjamin

>
>  thanks,
>
>  greg k-h
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe netdev" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
