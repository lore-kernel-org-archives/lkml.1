Return-Path: <linux-kernel-owner+w=401wt.eu-S1756419AbZD0WAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbZD0WAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZD0WAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:00:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34490 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZD0WAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:00:14 -0400
Date: Tue, 28 Apr 2009 06:54:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 6/8] sh: Use __INIT macro instead of .text.init.
Message-ID: <20090427215456.GA5033@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Jeff Arnold <jbarnold@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu> <1240855347-19316-2-git-send-email-tabbott@mit.edu> <1240855347-19316-3-git-send-email-tabbott@mit.edu> <1240855347-19316-4-git-send-email-tabbott@mit.edu> <1240855347-19316-5-git-send-email-tabbott@mit.edu> <1240855347-19316-6-git-send-email-tabbott@mit.edu> <1240855347-19316-7-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240855347-19316-7-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:02:25PM -0400, Tim Abbott wrote:
> The sh architecture has some code in the .text.init section, but it
> does not reference that section in its linker scripts.
> 
> This change moves this code from the .text.init section to the
> .init.text section, which is presumably where it belongs.
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Paul Mundt <lethal@linux-sh.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
