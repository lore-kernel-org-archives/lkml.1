Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYJGTKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYJGTKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYJGTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:09:56 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4981 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJGTJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:09:56 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 15:09:55 EDT
Date: Tue, 7 Oct 2008 18:54:10 +0000
From: root <thunder7@xs4all.nl>
To: linux-fb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: uvesafb in 2.6.27-rc9 uses mode_option, in 2.6.27 mode, but the
	docs aren't updated
Message-ID: <20081007185410.GA7872@onderneming10>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just tested 2.6.27-rc9 on my laptop, which uses uvesafb. I notice that
I need to update

/sbin/modprobe uvesafb mode=1400x1050

to

/sbin/modprobe uvesafb mode_option=1400x1050

but the documentation in Documentation/fb/uvesafb.txt happily talks
about the mode option. It would be nice to have the documentation
updated at least, but might I also question this move at all? Why call
something 'mode_option' when 'mode' is shorter and the fact that it's an
option really is clear from the fact you mention it on the commandline,
like, how-do-I-call-it, yes-I-remember, an option?

Or are we moving toward 'mtrr_option', 'scroll_option',
'vram_remap_option' etc? I don't think that really a good idea, so the
easiest thing to do would be to revert the patch that did this rename,
since that resyncs the Documentation to the actual module and removes
the needless description of the 'mode' option.

Kind regards,
Jurriaan
