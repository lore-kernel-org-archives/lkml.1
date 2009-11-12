Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKLQGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKLQGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZKLQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:06:42 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47419 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbZKLQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:06:42 -0500
Message-Id: <1258042007.31158.1344897055@webmail.messagingengine.com>
X-Sasl-Enc: f9arnP6NJbNfouYlC7kbEjjJwBLY4kuUx/qRlJXgvcoE 1258042007
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4AFACC03.7080209@mayc.ru><4AFB2822.30906@gmail.com><20091112021209.GA21625@khazad-dum.debian.net>
 <20091112110949.339c0c64@lxorguk.ukuu.org.uk>
Subject: Re: Reading /dev/mem by dd
In-Reply-To: <20091112110949.339c0c64@lxorguk.ukuu.org.uk>
Date: Thu, 12 Nov 2009 14:06:47 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 11:09 +0000, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 12 Nov 2009 00:12:09 -0200 Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Wed, 11 Nov 2009, Robert Hancock wrote:
> > > I don't think that we prevent any access to device registers in
> > > /dev/mem - if you read something that has side effects and
> > > something breaks, well I guess you get to keep both pieces :-)
> > > There's a reason it's root-only..
> >
> > We should.  Imaging /dev/mem is one of the oldest tricks in the book
> > of the forensics people, they do it to live systems to help track
> > down WTF happened to a compromised host.  This kind of crap bites
> > them hard.
>
> Any forensics person who images /dev/mem needs to go back to school.

While I do agree with you, I can assure you they do it all the time at
least around here, and it is still listed as "best practice" in the
notebooks of many.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

