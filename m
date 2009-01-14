Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZANUNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZANUNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZANUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:13:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:33612 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZANUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CgKSh6H8E27QW98D6set+CiMAQCJ6jQ/EPx+p/OfT/QepSo0epvDg8NPaKX+CIHsFp
         tjhwtCGwHimP9mUxuatJpxkVt6U54+xo7Fu3JXFuH3MKe1JsoAPmXQjS8wBw98lXWRdH
         ETTuLZJ2osCD8L0k9uGsQlJ8J68zp6WRxMof4=
Subject: Re: [PATCH -tip] nubus.h: extern's make no sense in userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114201019.GB1556@uranus.ravnborg.org>
References: <1231832906.3212.24.camel@jaswinder.satnam>
	 <Pine.LNX.4.64.0901131001200.19352@vixen.sonytel.be>
	 <1231963461.5756.9.camel@brick> <20090114201019.GB1556@uranus.ravnborg.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 12:13:19 -0800
Message-Id: <1231963999.5756.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 21:10 +0100, Sam Ravnborg wrote:
> On Wed, Jan 14, 2009 at 12:04:21PM -0800, Harvey Harrison wrote:
> > 
> > I had a look at this file, there's the small patch that just wraps the whole
> > section of function declarations with ifdef __KERNEL, or the larger patch
> > that does the wrapping _and_ adds the missing externs to make it obvious.
> > 
> > But I'm not sure that there is agreement regarding adding the externs too.
> > 
> > What do people think?
> 
> The general consensus is to add externs for new prototypes.
> So if _and only if_ you are anyway touching this file in that area then
> I would say - add the externs. But just adding externs are not (yet)
> worth a patch alone.
> 

Agreed about just adding externs not being worth it, but as part of auditing
this file for userspace inclusion I'll send the patch that adds the externs
as well as the ifdef __KERNEL__ bits.


Harvey

