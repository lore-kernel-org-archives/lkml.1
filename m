Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYHQMo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYHQMo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYHQMoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:44:21 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34988 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYHQMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:44:21 -0400
Date: Sun, 17 Aug 2008 14:44:04 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: sysprof in 2.6.27 kernel
Message-ID: <20080817124404.GR4674@ics.muni.cz>
References: <20080813083953.GF19333@ics.muni.cz> <ye8myjg7b4r.fsf@camel10.daimi.au.dk> <20080814115620.GD4674@ics.muni.cz> <ye8zlnd6589.fsf@camel28.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ye8zlnd6589.fsf@camel28.daimi.au.dk>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 17 Aug 2008 14:44:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 04:52:54AM +0200, Soeren Sandmann wrote:
> > and another one. sysproc gui reads user addresses from the sysprof pipe with
> > null pointers. is this ok or is this a bug in sysprof kernel module?
> 
> That is not ok, but it could happen if the process in question was not
> compiled with framepointers. Or it could be a bug in the kernel code.

I tried to put printf in case that sysprof gui receives non null address from
the kernel. None print was displayed, so it seems ti receives only null
addresses.

-- 
Luká¹ Hejtmánek
