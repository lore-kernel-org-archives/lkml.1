Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbYHEUq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbYHEUq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbYHEUpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:45:13 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:38025 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbYHEUpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:45:11 -0400
Date: Tue, 5 Aug 2008 22:45:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080805204548.GD5464@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <200808051418.05324.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808051418.05324.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:18:05PM +1000, Rusty Russell wrote:
> On Tuesday 29 July 2008 06:05:00 Sam Ravnborg wrote:
> > is is suggested to move the arch specific files under arch/
> > and for the header files this is arch/$ARCH/include.
> 
> Well, it would have been nice to take the opportunity to separate user-visible 
> header files and non-user-visible files.  We could have left the user-visible 
> ones in place, for example: diffstat would then show when you were frobbing 
> the userspace interface.

I would like to see this change too - but intentionally I would
not try to mix it with the move of the header files. Lets get the
move done now and fix the fall-outs, then we can take this logical next step.

	Sam
