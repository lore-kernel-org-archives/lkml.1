Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZI3VbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZI3VbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZI3VbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:31:22 -0400
Received: from [195.41.46.236] ([195.41.46.236]:57285 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZI3VbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:31:22 -0400
Date: Wed, 30 Sep 2009 23:31:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] arm: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090930213118.GA15732@merkur.ravnborg.org>
References: <1254345935-15958-1-git-send-email-tabbott@ksplice.com> <1254345935-15958-2-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254345935-15958-2-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 05:25:34PM -0400, Tim Abbott wrote:
> This has the consequence of changing the section name used for head
> code from ".text.head" to ".head.text".  Since this commit changes all
> users in the architecture, this change should be harmless.
> 
> The .text.head output section is eliminated and the head text code is
> included at the start of the .init output section.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
