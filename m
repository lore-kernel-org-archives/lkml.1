Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYDJASr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYDJASr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYDJASi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:18:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45272 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753244AbYDJASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:18:37 -0400
Date: Wed, 9 Apr 2008 19:18:33 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: gregkh@suse.de, bert.wesarg@googlemail.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-Id: <20080409191833.38cc13e3.pj@sgi.com>
In-Reply-To: <47FD2E3B.5010801@sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
	<20080409203909.GA17183@suse.de>
	<47FD2E3B.5010801@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> Btw, where does one value per file come from?  I see outputs like:
> ... /proc/self/stat

The one value per file rule comes in part from files such as this
stat file.  We've been learning the hard way that complex ascii file
formats tend to be a pain to parse, and a pain to evolve.  So we're
trying to do better in future files.  Greg K-H has been especially
clear on the need to do this in /sys files.  We can't change the format
of old files very well, but we can do better with new files we add.
The one most common exception to this rule that I find persuasive is
for a vector of values of the same type and semantics.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
