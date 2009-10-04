Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZJDWng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZJDWng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZJDWnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:43:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43124 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZJDWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:43:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Date: Mon, 5 Oct 2009 00:43:56 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1254669853.26496.0.camel@carter> <200910042246.23712.rjw@sisk.pl> <4AC91578.2020807@suse.de>
In-Reply-To: <4AC91578.2020807@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910050043.56667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 October 2009, Alexey Starikovskiy wrote:
> Hi Rafael,

Alex,

> This is not my rule, it was/is the rule of power device class. If you do not agree to it, please change
> appropriate documentation.

I think we're talking about two different things.  One thing is that we
shouldn't put any _arbitrary_ interpretation rules into the kernel, which I
agree with.  The other one is that if there's a _known_ _broken_ hardware
and one possible way of handling it is to add a quirk into the kernel, we
should at least consider doing that.

In my opinion adding a quirk for a broken hardware is not equivalent to
"inferring not available properties using some heuristics or mathematical
model", if that's what you're referring to.

That said, the patch should not change the _default_ code in order to handle
the quirky hardware correctly.  IMO, the quirky hardware should be recognized
during initialisation, if possible, and later handled in a special way.  If
it's not possible to detect the broken hardware reliably, I agree that there's
nothing we can do about that in the kernel.

Thanks,
Rafael
