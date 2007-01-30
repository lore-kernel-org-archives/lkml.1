Return-Path: <linux-kernel-owner+w=401wt.eu-S964854AbXA3EH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854AbXA3EH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXA3EH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:07:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:49652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854AbXA3EH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:07:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cbe-oss-dev@ozlabs.org, maynardj@us.ibm.com
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile for profiling Cell BE SPUs -- update
Date: Tue, 30 Jan 2007 05:07:46 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F2A.5040702@us.ibm.com>
In-Reply-To: <45BE4F2A.5040702@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701300507.47068.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+GJT8ENbL4J7N6U6PYcKh8QLKfYS8oxMRooPcMrevYizKB+mTf5iQ11w1dJM0bYGTd+XUuB50UCXgOoXOSWEvpxHAuXEYavdQ1hL8bAwJ7zw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 January 2007 20:46, Maynard Johnson wrote:
>   This is a clean up patch that includes the following changes:
> 
>         -It removes some macro definitions that are only used once
>          with the actual code.
>         -Some comments were added to clarify the code based on feedback
>          from the community.
>         -The write_pm_cntrl() and set_count_mode() were passed a structure
>          element from a global variable.  The argument was removed so the
>          functions now just operate on the global directly.
>         -The set_pm_event() function call in the cell_virtual_cntr() routine
>          was moved to a for-loop before the for_each_cpu loop
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>
> Signed-off-by: Maynard Johnson <mpjohn@us.ibm.com>
> 

Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

Just a small side note: Please give each of your patches a one-line
summary in the subject of the email. I'm filing this one under:
"cell: oprofile cleanup".

It would also be good if you could use a mailer that sends out
patches as inline, so you don't need to resort to using attachments.

	Arnd <><
