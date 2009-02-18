Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZBRRsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZBRRsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZBRRsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:48:15 -0500
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:59569 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754535AbZBRRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:48:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=BwD+9Jo54vZzXYmyUp1MpsBXplN4lrVykNREWzExlpsjQpCcD30fWBFGkOmDduvzj+i2uOgMfMRa0HSYOHNEdG4aTPo6C1od1KnoHIGzrujhJs3eyZ7q6ljWqt66UTyx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFD] Automatic suspend
Date: Wed, 18 Feb 2009 09:48:04 -0800
User-Agent: KMail/1.9.10
Cc: Brian Swetland <swetland@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-15?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <20090217152811.GA12686@bulgaria.corp.google.com> <1234924840.14060.342.camel@pasglop>
In-Reply-To: <1234924840.14060.342.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902180948.06039.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 6:40 pm Benjamin Herrenschmidt wrote:
> > You will end up with some crappy apps that do really dumb things.
> > However, even if they're badly written users may still install and use
> > these apps because hey, they do something the user likes.
> >
> > >From the Android standpoint, we're trying to balance protecting the
> >
> > system from poorly designed apps and somehow letting the user know "hey
> > app X is chewing up a lot of power" (work in progress on this).
> >
> > While I'd love for every app developer to actively tune their apps for a
> > good mobile experience, I am skeptical that this is going to happen.
>
> One idea I've been toying around was to have powertune as some kind of
> background thingy, and have it pop an icon in the notification area when
> some app seems to behave badly (of course, defining "badly" is hard but
> heh...). IE. actively inform the user "this application is sucking the
> life out of your battery".

I think "powernag" would be a better name, and it would probably work pretty 
well.  Users would be notified that certain apps should probably be shut down 
while they're on battery, and nag the authors to fix it.

-- 
Jesse Barnes, Intel Open Source Technology Center
