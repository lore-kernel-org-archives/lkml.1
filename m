Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYAVIZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYAVIZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 03:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYAVIZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 03:25:05 -0500
Received: from ag-out-0708.google.com ([72.14.246.240]:28973 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYAVIZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 03:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HXwZLnSdtiyNsT4EmmBbSl8IcQnp7k1MVi9wBjO16V+hryaO9BeLDOVXAmasNlUS2koUdYA5dqiCAAMbtemLX9705sDZO2I4vSG5O8CGZ13mavPieU0tIzryTDlKSClgxFIH0fVBkcvD0po9K7ugehZee4hcHgZ5YNwhCwktDxw=
Message-ID: <a8e1da0801220024u30e9c814va74e44252fc8b11e@mail.gmail.com>
Date: Tue, 22 Jan 2008 16:24:58 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth : move children of connection device to NULL before connection down
Cc: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       cornelia.huck@de.ibm.com, gombasg@sztaki.hu, htejun@gmail.com,
       viro@zeniv.linux.org.uk, kay.sievers@vrfy.org, greg@kroah.com
In-Reply-To: <1200982696.7978.148.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080121044913.GA4162@darkstar.te-china.tietoenator.com>
	 <20080121045401.GB4162@darkstar.te-china.tietoenator.com>
	 <20080121.031417.171098597.davem@davemloft.net>
	 <1200982696.7978.148.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 2:18 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > > Add people missed in cc-list.
> >
> > Thanks Dave for your continued efforts on Bluetooth bugs like this.
> >
> > Marcel, are you going to review/ACK/integrate/push-upstream/whatever
> > any of these Bluetooth patches?
> >
> > It hasn't been getting much love from you as of late, you are one of
> > the listed maintainers, and I don't want to lose any of Dave's
> > valuable bug fixing work.

Thanks.

>
> I will be fully back in business next week. Just got stuck in a project
> that needed 200% of my time to get it going.
>
> > Or should I just handle it all directly?
>
> I followed the list only a little bit, but from what I have seen is that
> Dave is doing a great job in tracking all issues down to the real cause.

Thanks.

>
> I had a look at his last patch and after review, I agree that this is a
> possible solution. I only have two nitpicks about the coding style. So
> in del_conn the struct device declaration should be made after the
> struct hci_conn assignment from the container and I would put an extra
> empty line before the devel_del, put_device block. Nitpicks only.

Marcel, could you tell something more about your coding style?
I would like to submit patches about bluetooth according to your sytle
later If I have.

Maybe you could put it on the bluez web site or anywhere.

>
> Right now I can't think of any side effects by this patch. Actually I
> only see an improvement with this patch. So please take it directly and
> starting with next week, I gonna make sure that they are handled again
> properly by me.
>
> Regards
>
> Marcel
>
>
>
