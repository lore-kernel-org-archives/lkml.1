Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442Ab0ANI0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0ANI0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018Ab0ANI0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:26:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54850 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0ANI0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=FSBaDuao9b5DrqP4+xP4temYGe81upwcelX3S9gbVv1Y2PWwjjLDsDM/CRQGlsw2w9
         hWQPpIyv42yLvhTeb+9XOJkkHR4I6S9vWTsdo/nQrAsVr+aBm6O3qgzVgRnlQFM5VxJJ
         nYFycH9fshnpnosMleVPacAVKEchkKgepQNPE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: Changelog quality
Date: Thu, 14 Jan 2010 00:26:30 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc4; KDE/4.3.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Julia Lawall <julia@diku.dk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
References: <20100113174446.GA20754@kroah.com> <20100113195226.GD8438@kroah.com> <4B4EAA73.5060103@freemail.hu>
In-Reply-To: <4B4EAA73.5060103@freemail.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001140026.31195.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 09:24:03 pm Németh Márton wrote:
> Greg KH wrote:
> > On Wed, Jan 13, 2010 at 01:04:52PM -0500, Alan Stern wrote:
> >> On Wed, 13 Jan 2010, Greg KH wrote:
> >>>> It would be nice if there was a way to link automatically a git commit
> >>>> to an archived copy of the email message in which it was originally
> >>>> submitted.
> >>>
> >>> Ingo has been doing this on some patches by putting a message-id field
> >>> in the signed-off-by area showing what lkml message a patch came from.
> >>>
> >>> See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
> >>> tree as an example of this.
> >>>
> >>> I have no objection if people want to do this for any patches going
> >>> through my tree as well.
> >>
> >> If it has to be included manually by the patch submitter then it isn't
> >> automatic.  Not to mention that the submitter would need to know the
> >> email's message-id before the email message was sent!
> >>
> >> Something like this should belong in a maintainer's script.
> >
> > Yeah, that would get messy, as usually a patch happens in a different
> > thread than the original problem occurs, so it would take a lot more
> > work on my part to try to match things up.  If I notice it, I will try
> > to in the future.
> 
> What about introducing a new tag like 'SmPL-Used:'? The used SmPL could
> be placed somewhere in the web. This would require only one line in
> the changelog: e.g.:
> 
> SmPL-Used: http://coccinelle.lip6.fr/sp.php#usb_submit_urb
> 
> Usually when an SmPL is created in a general manner it can easily
> match 100+ places. These can be combined in groups which for example
> belong to one maintainter. That was what I did with adding const to
> the different ID tables.
> 

Hm, I usually am only marginally interested in how patch was generated,
you may have used a script to 'ed' to generate it for all I care.
I do care however about rationale behind the change and that is what
should go into changelogs.

So if these scripts could go below the "---" separator I'm all for it.

Thanks.

-- 
Dmitry
