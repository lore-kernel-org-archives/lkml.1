Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXJWXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXJWXeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXJWXeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 19:34:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48844 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbXJWXeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 19:34:08 -0400
X-Sasl-enc: qR28FD0gY0elZ3sUM6/OWU7Yj9kM2HthWDLVQEM0SkFy 1193182446
Date: Tue, 23 Oct 2007 21:34:03 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071023233403.GD8224@khazad-dum.debian.net>
References: <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com> <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org> <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com> <20071017162827.GA9778@srcf.ucam.org> <20071017173532.GB2974@khazad-dum.debian.net> <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com> <20071017204250.GA13377@khazad-dum.debian.net> <d120d5000710180737yeba5445tdb3b302ed6f7a802@mail.gmail.com> <20071018223915.GA4483@khazad-dum.debian.net> <d120d5000710230854j28502be6xd5a0fd8d2fab3b77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000710230854j28502be6xd5a0fd8d2fab3b77@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007, Dmitry Torokhov wrote:
> in question. Probably simply adding separate key notify events (such
> as KEY_BRIGHTNESSUP_NOTIFY) to EV_KEY instead of creating EV_NOTIFY is
> not such a bad idea - this way we can fix keymap from userspace (if
> needed) instead of needing to modify the krenel.

That is a killer argument for EV_KEY over EV_NOTIFY if I have ever seen one.

> So, EV_KEY (and extending KEY_MAX to 1024) or EV_NOTIFY?

EV_KEY, please.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
