Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZKLSMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZKLSMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZKLSMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:12:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43806 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754030AbZKLSME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:12:04 -0500
Date: Thu, 12 Nov 2009 18:13:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091112181350.68c866e7@lxorguk.ukuu.org.uk>
In-Reply-To: <1258048669.20754.1344916801@webmail.messagingengine.com>
References: <4AFACC03.7080209@mayc.ru>
	<4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
	<878web7kwf.fsf@basil.nowhere.org>
	<1258047454.16197.1344913359@webmail.messagingengine.com>
	<20091112174916.59fe7805@lxorguk.ukuu.org.uk>
	<1258048669.20754.1344916801@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 15:57:49 -0200
"Henrique de Moraes Holschuh" <hmh@hmh.eng.br> wrote:

> On Thu, 12 Nov 2009 17:49 +0000, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> > > In this case, the problem seems to be access over /dev/mem to stuff the
> > > kernel is already taking care of.  Certainly "as safe as possible" does
> > 
> > Which is often what is desired - eg debugging driver stuff.
> > 
> > > not have to mean making /dev/mem useless for whatever good uses it has.
> > 
> > It does. Plain and simple.
> 
> Is that the only valid use of /dev/mem, or even its main use?

These days it is the primary use. Things like X11 were historically
probably the biggest user of it, and things like LRMI sometimes need that
sort of stuff.

The X case also involves X and the kernel both working with the same
resource and in many cases that resource having registers that can crash
a system if mis-accessed.

Alan
