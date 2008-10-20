Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYJTOeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYJTOeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYJTOeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:34:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:14725 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbYJTOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JvgRXr9eMuFAB6wVFsryWhDg0iKEDQ2EN12MYkR0Pw6jB33qJ9YSeLK8q53g5fJIun
         QW96rXIt7UBqHcJBzkocxImu7fzHLGTH1hwhFAJYoY9/98+AuPxVDqHlBCZsEO4nWtK2
         dYyZJJZCYOQXMUDhIpIfzyzep3w3JIYw8jhuQ=
Date: Mon, 20 Oct 2008 18:34:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Max Kellermann <mk@cm4all.com>
Cc: Glauber Costa <glommer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
Message-ID: <20081020143409.GB25166@localhost>
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer> <20081020065149.GA11213@rabbit.intern.cm-ag> <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com> <20081020141258.GA8228@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020141258.GA8228@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Max Kellermann - Mon, Oct 20, 2008 at 04:12:58PM +0200]
| On 2008/10/20 15:15, Glauber Costa <glommer@gmail.com> wrote:
| > There's a patch in flight from cyrill that probably fixes your
| > problem: http://lkml.org/lkml/2008/9/15/93
| > 
| > The checks are obviously there for a reason, and we can't just wipe
| > them out unconditionally ;-) So can you check please that you are
| > also covered by the case provided?
| 
| Looks good: booted the machine 30 minutes ago, no problems so far.
| 
| Max
| 

Thanks Max for testing! (me -- wonders since the patch helped
for now :-)

		- Cyrill -
