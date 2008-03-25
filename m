Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYCYSVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYCYSVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYCYSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:21:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYCYSVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:21:43 -0400
Date: Tue, 25 Mar 2008 19:22:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel compilation: make halts with error message "*** target pattern contains no `%'"
Message-ID: <20080325182205.GA29986@uranus.ravnborg.org>
References: <e2e108260803250115j4047b242t85c4d719501482bf@mail.gmail.com> <e2e108260803250815n68838589h90f6129062c8f665@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260803250815n68838589h90f6129062c8f665@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 04:15:49PM +0100, Bart Van Assche wrote:
> On Tue, Mar 25, 2008 at 9:15 AM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> >  When I try to compile the latest git tree
> 
> Found the cause: apparently this is what happens when the path
> containing the kernel source tree contains a colon. Renaming the
> kernel source tree directory solved this issue.

Thanks for letting us know.
And using 'colon' in the path is a "don't do that" thing that
we will not try to check for.

	Sam
