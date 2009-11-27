Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZK0Vg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZK0Vg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 16:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZK0Vg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 16:36:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:22908 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZK0Vgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 16:36:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cp0PUf37ISFI01/EW1iQfJqTRncTsA1T1oZkDibW0nOWINysq6HN3prqh1aIK+eXBW
         It2iPSYJyHjhSJewZqkMgmaA/AqxSNOgd5EIAD4RBPNCsOrMvj46q6AjN0ue2Aajci00
         1rhilLuMFwDlohGMyDGcH/l2HsKuN/KjW71P0=
Date: Fri, 27 Nov 2009 22:36:40 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091127213640.GA2611@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
 <20091124111946.GA7883@ff.dom.local>
 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
 <20091125191105.GA3167@ami.dom.local>
 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 01:07:53PM -0500, Caleb Cushing wrote:
> 2.6.32-rc8 seemed to be affected (guess. because my net didn't come up
> on reboot. further testing will likely verify) also during reboots I
> found out that the version I've been thinking is good is afflicted. I
> supposed maybe I should try bisecting again? starting with that point.
> not sure it'll do us much good if that version was able to slip by for
> so long. I really hate intermittent bugs.

I doubt bisecting is a good idea with so unpredictable bug. First, you
should make sure it's not a hardware problem, so go back to the kernel
you trust most, and give it a really long try with a few recompilations
after slightly changing the config. Btw, I wonder if you tried e1000e
module parameters like IntMode=0 or 1.

Jarek P.
