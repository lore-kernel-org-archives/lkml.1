Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbXGXVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbXGXVrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGXVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:47:44 -0400
Received: from iona.labri.fr ([147.210.8.143]:43788 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbXGXVrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:47:43 -0400
Date: Tue, 24 Jul 2007 23:47:36 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Cc: Egmont Koblinger <egmont@uhulinux.hu>
Subject: Re: console UTF-8 fixes
Message-ID: <20070724214736.GL3700@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, Egmont Koblinger <egmont@uhulinux.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Egmont got some UTF-8 fixes in mainline, Andrew Morton suggested it
might be a good time to remember about bug 7746 Support for unicode dead
keys: http://bugzilla.kernel.org/show_bug.cgi?id=7746 :

« Quoting a mail from Vojtech Pavlik:

"Several languages (polish, czech, slovak, ...) use dead keys (keys that
don't do anything per se, but put an accent on the next letter). And
now almost everyone is switching to unicode. And Linux kernel doesn't
support unicode for dead keys. This means trouble."
(full mail at
http://www.ussg.iu.edu/hypermail/linux/kernel/0405.3/1387.html)

And indeed, see http://bugs.debian.org/404503

There is a more recent patch proposed on
http://www.ussg.iu.edu/hypermail/linux/kernel/0503.2/1723.html

Is there any objection to the proposed way? (extending the internal
type, and add a new ioctl for uploading unicode dead keys). »

Samuel
