Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYBJFIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYBJFIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 00:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYBJFIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 00:08:40 -0500
Received: from keil-draco.com ([216.193.185.50]:50700 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYBJFIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 00:08:38 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Sun, 10 Feb 2008 00:07:49 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: davids@webmaster.com, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, Christer Weinigel <christer@weinigel.se>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com> <1202619017.7664.53.camel@violet>
In-Reply-To: <1202619017.7664.53.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802100007.50441.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008 23:50:17 Marcel Holtmann wrote:
<snip>
> > > It makes no difference if you
> > > distribute the GPL library with it or not.
> >
> > If you do not distribute the GPL library, the library is simply being
> > used in the intended, ordinary way. You do not need to agree to, nor can
> > you violate, the GPL simply by using a work in its ordinary intended way.
> >
> > If the application contains insufficient copyrightable expression from
> > the library to be considered a derivative work (and purely functional
> > things do not count), then it cannot be a derivative work. The library is
> > not being copied or distributed. So how can its copyright be infringed?
>
> go ahead and create an application that uses a GPL only library. Then
> ask a lawyer if it is okay to distribute your application in binary only
> form without making the source code available (according to the GPL).
>
> http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#IfLibraryIsGPL
>
> http://www.gnu.org/licenses/old-licenses/gpl-2.0-faq.html#LinkingWithGPL
>
> Regards
>
> Marcel

In the US, at least, the belief that "Linking", in *ANY* form, with a GPL 
library creates a derivative work, is fallacious. Were I to create an 
application that uses, say, GTK for the interface the protected expression is 
my "unique and creative" use of the GTK API for creating the specific 
interface and any other code I have written using the API. I hold sole 
license to the copyright on that code and am able to license said code under 
the specific license of my choice.

Why? Because the pre-processor is what is including any GPL'd code in my 
application and expanding any macros. That is a purely mechanical process and 
hence the output is not able to be separately copyrighted - if it could be, 
then the copyright would be held by the *COMPILER*, and I am *NOT* bound by 
the license on that code. The same applies if GPL'd code is included in my 
application during the linking process. QED: The "Linking" argument used by 
most people is wholly fallacious in at least one major country - and if I'm 
not mistaken, the output from an automated process is similarly not 
considered as carrying a separate copyright in all nations that are 
signatories of or follow the Bern Convention.

(And yes, this also applies to some GPL'd tools that RMS extended "GPL 
Exemptions" to - such as "Bison". There is, generally, no need for such an 
exemption, because  the process by which the GPL'd code is included in the 
final binary is wholly mechanical.)

DRH
PS: The above information is a very condensed form of the result of several 
past conversations on this list about copyright law and the GPL as well as my 
own, private discussions with lawyers. I'm being lazy here and not searching 
various archives of LKML to give pointers to the past discussions.

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
