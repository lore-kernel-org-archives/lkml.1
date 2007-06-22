Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbXFVQUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbXFVQUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757824AbXFVQUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:20:22 -0400
Received: from gw.goop.org ([64.81.55.164]:41131 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416AbXFVQUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:20:21 -0400
Message-ID: <467BF69D.4030806@goop.org>
Date: Fri, 22 Jun 2007 09:19:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
 together
References: <20070622080634.GP3723@sequoia.sous-sol.org> <20070622083330.GB19382@elte.hu> <20070622152915.GQ3723@sequoia.sous-sol.org>
In-Reply-To: <20070622152915.GQ3723@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> Yes, I agree, it's actually documenting the subtlety of the calling
> convention, not just noise in the source.  The upstream patch is
> different, I'll sort one out.

I wonder if we should use something like "regparm" rather than 
"fastcall"?  The latter makes it sound like its just a performance issue.

    J

