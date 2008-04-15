Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbYDOGMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYDOGMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYDOGL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:11:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59456 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYDOGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nqY1hbqj4RHflrlWsGTLFkj7ECqex4QoIjZC6RjfI0qMSEXKvKMAea3TcjhwP6+1ZlF9a9MvRESy8LHT1/zoHz8lO6lN4Q69JjxwvhL92MtuP8DnvdntZiakWZO3oD8gb7pUDuJaC4bFpuyYnAohnuCUqP7BpBezN8fpCB4IMN0=
Message-ID: <e2e108260804142311r7ca31d29m7221ca8935a79f35@mail.gmail.com>
Date: Tue, 15 Apr 2008 08:11:54 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: AMD Quad Core clock problem?
Cc: "Marc Perkel" <mperkel@yahoo.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4803AD83.4030807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <303918.65020.qm@web52503.mail.re2.yahoo.com>
	 <4803AD83.4030807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 9:16 PM, Chris Snook <csnook@redhat.com> wrote:
> Marc Perkel wrote:
>
> > My best guess at this time is that the drift of this
> > computer using the quad core is so great that the ntpd
> > can't get in sync. Is there any way to make ntpd more
> > agressive by setting something in ntp.conf?
> >
>
>  ntp can correct for 500 ppm drift, which equates to 1.8 seconds per hour.
> Beyond that you need to run ntpdate or ntpd -gq from cron to correct it.

It's better to correct the clock frequency once with the tickadj or
adjtimex, so you don't have to add ntpdate to cron and you can still
run ntpd.

Bart.
