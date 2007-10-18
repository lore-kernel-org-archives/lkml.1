Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXJRWjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXJRWjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbXJRWjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:39:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35701 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759428AbXJRWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:39:21 -0400
X-Sasl-enc: mg0a51MhpZFkcvl/JFV8YYtfqsn1gH/8lAb5nhq3FEA/ 1192747159
Date: Thu, 18 Oct 2007 20:39:15 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071018223915.GA4483@khazad-dum.debian.net>
References: <20071016184606.GB25181@srcf.ucam.org> <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org> <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com> <20071017162827.GA9778@srcf.ucam.org> <20071017173532.GB2974@khazad-dum.debian.net> <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com> <20071017204250.GA13377@khazad-dum.debian.net> <d120d5000710180737yeba5445tdb3b302ed6f7a802@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710180737yeba5445tdb3b302ed6f7a802@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Dmitry Torokhov wrote:
> On 10/17/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > Still, I was
> > thinking about it, and a doubt came to mind: would it cause problems for a
> > bitmap to share the function for EV_foo and EV_foo notifications?
> 
> Not sure if I follow... Are you talking about bringing KEY_*_NOTIFY
> into EV_KEY "namespace"? Could you elaborate?

Suppose we define a "EV_* is a notify event" bit to set in the event type
field of an input event.

Now, any type of event can be a notify event or a normal event, depending on
wether this bit is set.

However, the input layer keeps track of which events of a given type can be
sent by an input device using bitmaps, for every type of event.  And this
bitmap now would mean "input device may issue a normal event or a notify
event", not just "input device may issue a normal event".

I am not sure if that would cause trouble?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
