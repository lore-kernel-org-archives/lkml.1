Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXDONHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXDONHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXDONHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:07:06 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:46311 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXDONHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:07:05 -0400
Date: Sun, 15 Apr 2007 15:07:01 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Luca Lucchesi" <shacky83@hotmail.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can't select "Video mode selection support" and "VGA 8x16 font"
Message-ID: <20070415150701.791858bc@localhost>
In-Reply-To: <BAY104-F34021EC2A3A0A254143883B3530@phx.gbl>
References: <BAY104-F34021EC2A3A0A254143883B3530@phx.gbl>
X-Mailer: Claws Mail 2.6.1 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007 13:08:54 +0200
"Luca Lucchesi" <shacky83@hotmail.it> wrote:

> but I can't select them because they are unselectable (they appear with 
> "---" in the left).
> I checked their requirements but all requirements seem to be active.
> 
> Why I can't active them?
> Somebody could help me, please?

"---" means that they _ARE_ active and you cannot deselect them
(because they are selected by something else)

try this:

	$ grep VIDEO_SEL .config
	CONFIG_VIDEO_SELECT=y

So you have nothing to do :)

-- 
	Paolo Ornati
	Linux 2.6.20.7 on x86_64
