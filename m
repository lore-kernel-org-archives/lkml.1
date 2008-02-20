Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYBTMmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYBTMmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYBTMm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:42:27 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:36577 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751464AbYBTMm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:42:26 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 23:41:55 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-ID: <20080220124155.GB2169@tull.net>
References: <20080219140609.GA26619@tull.net> <20080219151214.GD27352@tull.net> <20080219093958.57144ce3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219093958.57144ce3.pj@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:39:58AM -0600, Paul Jackson wrote:
> I don't think /proc/<pid>/cpuset (PROC_PID_CPUSET) is, or should be,
> deprecated.

Ok, I had just picked up on the "legacy" word in the option title
and assumed that it meant deprecated.

This is what I've got now:

 config PROC_PID_CPUSET
        bool "Include legacy /proc/<pid>/cpuset file"
        depends on CPUSETS
        default y
+       help
+         This option provides the /proc/<pid>/cpuset file.
+
+         This file contains the name of the cpuset in which
+         the process is executing. For more information, see
+         <file:Documentation/cpusets.txt>
+
+         If unsure, say Y.

In general, are option titles fragile? For example, if I were to submit
a patch which changes an option's title string, is this likely to break
something or somebody?

Nick.
