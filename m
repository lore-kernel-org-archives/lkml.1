Return-Path: <linux-kernel-owner+w=401wt.eu-S1752806AbXFXWGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbXFXWGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXFXWGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:06:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:45642 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXFXWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MaqmC9gqZ1MeVDeHmvtU6ynzmfkmJqpF6Zx4gXkjEfRD8LV9YSZHScWOk2Ao/7KdAZBILgmmk5/1v0LScRjDn1SyQLCDoEB1Y5swFneODbMMUw9Lu2hBm2bYe+ACwv/MJn3xK5jGblZ+QdC+vTPQwoVhLAhjGXF0BrVXpso8i18=
Message-ID: <15e53e180706241506p53ec648ib93d684bbe076a46@mail.gmail.com>
Date: Sun, 24 Jun 2007 23:06:37 +0100
From: GMail <hughsient@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [patch] Reporting the lid status using INPUT
Cc: linux-acpi <linux-acpi@vger.kernel.org>, a_bartok@freemail.hu,
       "Bastien Nocera" <hadess@hadess.net>, "David Zeuthen" <david@fubar.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200706161351.28885.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181910567.4819.7.camel@work> <1181919208.2681.6.camel@work>
	 <1182013911.2309.4.camel@work> <200706161351.28885.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Saturday 16 June 2007 13:11, Richard Hughes wrote:
> > On Fri, 2007-06-15 at 15:53 +0100, Richard Hughes wrote:
> > > On Fri, 2007-06-15 at 10:29 -0400, Dmitry Torokhov wrote:
> > > > On 6/15/07, Richard Hughes <hughsient@gmail.com> wrote:
> > > > > On Fri, 2007-06-15 at 13:29 +0100, Richard Hughes wrote:
> > > > > > in response to an event, but I'm thinking in a resume hook we should
> > > > > > probably do acpi_evaluate_integer(handle, "_LID", NULL, &state) and then
> > > > > > send an event, just so userspace is aware of what the state of the panel
> > > > > > is.
> > > > >
> > > > > Attached patch fixed the issue for me. Comments?
> > > > >
> > > >
> > > > The patch makes perfect sense. The only issue I have is this:
> > > >
> > > > > +       /* on resume we send the state; it might be the same, but userspace
> > > > > +        * should handle duplicated events */
> > > >
> > > > If switch state matches to what input layer thinks it is the event
> > > > will not even reach userspace.
> > >
> > > Okay, new patch attached, thanks for the speedy review.
> >
> > This fix is also confirmed by somebody else, see
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=243030
> >
> > It would be great if this could go into .22, although I appreciate it's
> > quite late in the day.
> >
>
> This is of course Len's call but in my book this is a bugfix and as such
> is appropriate for -rc4/rc5.

Guys? Any ack-nak?

Richard.
