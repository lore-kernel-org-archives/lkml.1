Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbZCXKxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbZCXKxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZCXKxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:53:33 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:57939
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755988AbZCXKxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:53:32 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 06:53:31 EDT
X-IronPort-AV: E=Sophos;i="4.38,412,1233529200"; 
   d="scan'208";a="37097453"
Date: Tue, 24 Mar 2009 11:43:32 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Miloslav Trmac <mitr@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Audit: Log TIOCSTI
Message-ID: <20090324104332.GD5541@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Miloslav Trmac <mitr@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just a late follow-up.

From: Miloslav Trmac <mitr@redhat.com>
> (The only program I could find that uses TIOCSTI is mailx/nail in
> "header editing" mode, e.g. using the ~h escape. mailx is used very
> rarely, and the escapes are used even rarer.)

TIOCSTI is used daily by people typing on a braille device.  The brltty
daemon uses TIOCSTI to synthesize the keypresses.  Yes, it can also
use uinput (and it does) but not in all case: uinput doesn't permit
to synthesize an 'A' (I really mean an ascii 'A', not the key whose
physical position is the position of 'A' on a qwerty keyboard).

Samuel
