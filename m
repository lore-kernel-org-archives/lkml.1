Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXEGG5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXEGG5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXEGG5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:57:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:14574 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbXEGG5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gSB9BbFqeH8gxvnXRNR3dBnLL+JiP4rq8yglOPuShXKDCX8KU1OAx7/MWNlxZn9z9CUGeBqSoWljFxgwdnqR7gR50qt1rB52QE22glruyacEB1FTGLjRxpSNOGjhMXRydFosxB8YssvEknh2hwnycYCBZJhKl293VqrxidvR3ng=
Message-ID: <416aa1ad0705062357i5a76684ao1d45ef235a6cd20f@mail.gmail.com>
Date: Mon, 7 May 2007 12:27:28 +0530
From: "kalash nainwal" <kalash.nainwal@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: select-like implementation for kernel sockets
Cc: eitanr@audiocodes.com, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <463E0DD3.9050909@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178449075.942407.164040@q75g2000hsh.googlegroups.com>
	 <463E0DD3.9050909@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/07, Robert Hancock <hancockr@shaw.ca> wrote:
> eitanr@audiocodes.com wrote:
> > Hi,
> >
> > I'm using kernel sockets to Tx and Rx UDP packets between my hardware
> > device (DSP) to the external network (this is part of a VoIP
> > implementation). The motivation for using kernel sockets rather than
> > user-space sockets is to avoid the copying of data between kernel and
> > user spaces.
>
> I think we are zero-copy in many cases for UDP these days, so this
> doesn't necessarily buy you anything..
>
> >
> > I have no problems on the Tx side (I simply call sock_sendmsg on one
> > of the sockets), but for the Rx side I want to listen-in on multiple
> > sockets in blocking mode (I don't want to use polling).
> >
> > Is there a way to listen-in on multiple kernel sockets from one kernel
> > thread? In the user space I would have used select(), but I am not
> > familiar with a similar solution for the kernel space.
> >

implementing (sock->)sk_data_ready() might serve your purpose?

> > Thanks,
> > Eitan.
> >
> > Eitan Richardson
> > AudioCodes Ltd.
> >
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
