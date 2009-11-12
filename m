Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbZKLUCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbZKLUCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZKLUCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:02:03 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:32788 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZKLUCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:02:02 -0500
Message-Id: <1258056127.11482.1344936807@webmail.messagingengine.com>
X-Sasl-Enc: VqQazRsbzDrZwk8QXnX5fMs1/N8KRUdwq2x3vZ46AnEP 1258056127
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4AFACC03.7080209@mayc.ru><4AFB2822.30906@gmail.com><20091112021209.GA21625@khazad-dum.debian.net><878web7kwf.fsf@basil.nowhere.org><1258047454.16197.1344913359@webmail.messagingengine.com><20091112174916.59fe7805@lxorguk.ukuu.org.uk><1258048669.20754.1344916801@webmail.messagingengine.com>
 <20091112181350.68c866e7@lxorguk.ukuu.org.uk>
Subject: Re: Reading /dev/mem by dd
In-Reply-To: <20091112181350.68c866e7@lxorguk.ukuu.org.uk>
Date: Thu, 12 Nov 2009 18:02:07 -0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 18:13 +0000, "Alan Cox" <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 12 Nov 2009 15:57:49 -0200 "Henrique de Moraes Holschuh"
> <hmh@hmh.eng.br> wrote:
> > On Thu, 12 Nov 2009 17:49 +0000, "Alan Cox"
> > <alan@lxorguk.ukuu.org.uk> wrote:
> > > > In this case, the problem seems to be access over /dev/mem to
> > > > stuff the kernel is already taking care of.  Certainly "as safe
> > > > as possible" does
> > >
> > > Which is often what is desired - eg debugging driver stuff.
[...]
> > Is that the only valid use of /dev/mem, or even its main use?
>
> These days it is the primary use. Things like X11 were historically
> probably the biggest user of it, and things like LRMI sometimes need
> that sort of stuff.

Well, if debugging is the primary use, maybe the best long term plan
would be to get rid of the need for /dev/mem for anything other than
debugging, and after that is accomplished, move it to debugfs or make
it optional?

> The X case also involves X and the kernel both working with the same
> resource and in many cases that resource having registers that can
> crash a system if mis-accessed.

I see.  That also tells me that whatever dark sides KMS has, it is much
better than the alternative :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

