Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbZAGTfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbZAGTfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbZAGTfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:35:23 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57167 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbZAGTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:35:22 -0500
Date: Wed, 7 Jan 2009 20:37:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Anders Larsen <al@alarsen.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Include <linux/types.h> for definitions of __[us]{8,16,32,64} types
Message-ID: <20090107193702.GB4647@uranus.ravnborg.org>
References: <1230826655-18495-1-git-send-email-al@alarsen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230826655-18495-1-git-send-email-al@alarsen.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 05:17:35PM +0100, Anders Larsen wrote:
> On 2008-12-30 11:32:33, Sam Ravnborg wrote:
> > We have added a few additional validation checks of the userspace headers:
> ...
> > 3) We should include <linux/types.h> and not <asm/types.h>
> > 4) If we use a __[us]{8,16,32,64} type then we must include <linux/types.h>
> 
> Satisfy these requirements for the linux/qnx*.h headers.
> 
> Signed-off-by: Anders Larsen <al@alarsen.net>

Applied to kbuild-fixes.git

Thanks,
	Sam
