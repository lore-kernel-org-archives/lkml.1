Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYBSKfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYBSKfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYBSKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:35:31 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:54599 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYBSKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:35:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Tue, 19 Feb 2008 11:34:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802190004.47594.mb@bu3sch.de> <Pine.LNX.4.64.0802190935450.25052@anakin>
In-Reply-To: <Pine.LNX.4.64.0802190935450.25052@anakin>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191134.59378.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 09:37:05 Geert Uytterhoeven wrote:
> On Tue, 19 Feb 2008, Michael Buesch wrote:
> > Still I can't see why this structure will cause alignment issues, as the
> > compiler will pad it up to the right boundary automagically, as you said
> > above. Why doesn't the ARM compiler do this?
> 
> The ARM compiler handles it correctly.
> 
> But the ugly hacks to get useful information about the module device
> table using the _host_ compiler fail.

Ok, fine. So I'm not going to apply this patch. We need
to fix the sanity check instead.

-- 
Greetings Michael.
