Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZGTXzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZGTXzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZGTXzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:55:16 -0400
Received: from solo.fdn.fr ([80.67.169.19]:36824 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbZGTXzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:55:15 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 19:55:15 EDT
Date: Tue, 21 Jul 2009 01:55:14 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: inotify on /dev/vcsa?
Message-ID: <20090720235514.GT5397@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-console@vger.kernel.org
References: <20090720234618.GR5397@const.famille.thibault.fr> <20090721005108.574d5145@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090721005108.574d5145@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Tue 21 Jul 2009 00:51:08 +0100, a écrit :
> I would have thought poll() would have been cleaner. Or perhaps extending
> the VT event interface I added to the vt drivers in the current patches
> pending for 2.6.32 - poll support would probably be a bit lighter as
> you'd just need to do something like
> 
> 	event_count++;
> 	wake_up(&vcsa_event_wait);
> 
> and check for a count change

Sounds like a good plan indeed.

Samuel
