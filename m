Return-Path: <linux-kernel-owner+w=401wt.eu-S937077AbXHGWYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937077AbXHGWYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932492AbXHGWXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:23:46 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:57856 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934547AbXHGWXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c16zg4ZdGa/19pDqR+r3n9M5TrTxAsgp0G/H5khK4/wLQ7+R5zJM8s0lYXJ0FeVX6hIKLtLw+YXFTVqS3juWtsYX7HPHTV+mMe6YPAX6MC9gs9BkfmEK7TiRo+cJWz0gs/+OkchJAc39juJffBGazTNBpU8k2fSxsjNKIz7WGlw=
Message-ID: <3ae72650708071523s24d80ae4v2590c50aea04c850@mail.gmail.com>
Date: Wed, 8 Aug 2007 00:23:42 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: 2.6.22: pcspkr driver no longer loads automatically
Cc: "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <46B8E773.5020406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B8C8FA.9020100@redhat.com> <46B8D984.7040602@garzik.org>
	 <46B8E773.5020406@redhat.com>
X-Google-Sender-Auth: b5294a09edbf2969
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> On 08/07/2007 04:43 PM, Jeff Garzik wrote:
> > Chuck Ebbert wrote:
> >> With no other changes but a kernel upgrade, the pcspkr driver
> >> doesn't load automatically anymore. No changes to that driver
> >> jump out, so where else could the problem be? Something to
> >> do with the device class changes maybe?
> >
> > This has long been a problem for me on Fedora, long before 2.6.22.  I
> > would never ever have the glorious system beeps, unless I built the
> > module into my kernel.
> >
> > I would look into distro areas and see why it's not getting loaded.
> >
>
> Seems to be some kind of udev / hal magic loading it. With 2.6.20/21
> it worked for most people, now it seems totally broken. Maybe we should
> just load it unconditionally.

It doesn't have any aliases, so seems it was never autoloaded.
It's like mousedev, and should probably just be built-in.

Kay
