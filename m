Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYDKViv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYDKViv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYDKVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:38:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35205 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755020AbYDKVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:38:44 -0400
Date: Fri, 11 Apr 2008 17:38:43 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
Message-ID: <20080411213843.GH2160@csclub.uwaterloo.ca>
References: <47FFD3F3.50107@redhat.com> <821384.64293.qm@web52504.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821384.64293.qm@web52504.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 02:36:31PM -0700, Marc Perkel wrote:
> No - it's not wild like it was back in the early X2
> days and I think you're right about the drift being
> normal. Interesting thing though I am running ntpd and
> it's not working. I am fairly sure the ntp.conf file
> is exactly as it was installed by fedora. I'm now
> looking into that.
> 
> Thanks for your help. Sorry for the false alarm. But
> if thee was an issue I thought you would want to know
> it.

I have found that ntp tends to fail to work on any machine with spread
spectrum clocking enabled.  On those machines disabling spread specturm
in the BIOS seems to fix it.  I had to update the BIOS on one machine to
even get the option to disable it though.

-- 
Len Sorensen
