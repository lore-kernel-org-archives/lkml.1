Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXIERXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXIERXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbXIERXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:23:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:59697 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXIERXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fuT/9XLIecsOgtGK2D6hjg5LBdOJk9tykmgl9qAnUYpGsg7svVSlqY4H8tyN+Lu9G+OL+IQfXecBjvV1Sl2RICe+AkQfxqQ2C+xxnWnZgZVxy2E5cQEMfuThdPomjmyF7/yLMrbPuHUPJZrDzXs+JwToI9Jt3u2AF19DzQ1WS2M=
Date: Wed, 5 Sep 2007 21:22:52 +0400
To: James Pearson <james-p@moving-picture.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Anton Arapov <aarapov@redhat.com>,
       Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
Message-ID: <20070905172252.GA2104@martell.zuzino.mipt.ru>
References: <4474B7DB.8000304@moving-picture.com> <200605242029.k4OKTn9C031700@terminus.zytor.com> <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com> <46C33700.1060605@zytor.com> <46D6CBED.4040301@moving-picture.com> <h87in5sgal.fsf@pepelac.englab.brq.redhat.com> <46DE6196.3050605@zytor.com> <46DEE0C9.1000402@moving-picture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DEE0C9.1000402@moving-picture.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 06:00:57PM +0100, James Pearson wrote:
> H. Peter Anvin wrote:
> >Anton Arapov wrote:
> >
> >>  Hey guys, the future of this patch is important for me. What do you 
> >>think, has this patch any chances to be committed to upstream?
> >>
> >>James Pearson <james-p@moving-picture.com> writes:
> >>
> >>>H. Peter Anvin wrote:
> >>>There isn't that much that is duplicated - and there are also bits of
> >>>the /proc/PID/mem code that are not needed in this case, so I'm not
> >>>really sure if it is worth doing.
> >>>
> >>>I did submit a patch a few months ago - see:
> >>>
> >>><http://marc.info/?l=linux-kernel&m=117862109623007&w=2>
> >>
> >>
> >
> >Looks reasonable to me, except for the one overlong line.
> >
> 
> OK, here is the patch (without the long line) against 2.6.23-rc5 - what 
> else needs to be done to get it committed?

Remove duplicate ptrace_may_attach() checks, unecessary (), {} and
spaces before pointer names -- char *buf.
