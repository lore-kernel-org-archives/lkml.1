Return-Path: <linux-kernel-owner+w=401wt.eu-S1030428AbXCAWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428AbXCAWPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030447AbXCAWPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:15:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:44250 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030428AbXCAWPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eOfMurOa8sR7vIpc6wnLy8GVDlEm3s7GqmNJlmB3buXlwGftKOPMP19R2QQ+/rUgdAJwHeyv4JNWdhPaDdn5Vxf6ci5sNHIaFGHUEfiejhIiI7pU6C0GOg1G1mMhkk0/1b8Cn9m+ehfk5+T6qaUKoJv+JOxiXyqU2jU1wcbRi9k=
Message-ID: <75b66ecd0703011415q200a07aavf10eb148ee8c5fdc@mail.gmail.com>
Date: Thu, 1 Mar 2007 17:15:30 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "WHITE, JOE (ASI-AIT)" <jw2365@att.com>
Subject: Re: 3c905B - Transmit error, Tx status register 82
Cc: andrewm@uow.edu.au, netdev@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <0D69EE79F863484FB73D20A95656730D02F9CBB3@ILNORT1MSGUSR18.ITServices.sbc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <75b66ecd0703011013h704319c4h9f5ad7b572c53b28@mail.gmail.com>
	 <0D69EE79F863484FB73D20A95656730D02F9CBB3@ILNORT1MSGUSR18.ITServices.sbc.com>
X-Google-Sender-Auth: adf2bc963dd0d2f3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, WHITE, JOE (ASI-AIT) <jw2365@att.com> wrote:
> Lee,
>
> Thanks for the reply.
>
> We have tried moving my network connection to a new switch, replaced the
> cables, but still getting that error.
>
> What do I do with that command options 3c59x full_duplex=1, where do I
> put it?  Bare with me as I am a newbie.

Easiest way to test is to shut down all networking, "rmmod 3c59x",
then "modprobe 3c59x full_duplex=1".

If that solves the problem you need to figure out where your distro
stores kernel module options and add it there.  They all do it
differently (for no good reason).

Lee
