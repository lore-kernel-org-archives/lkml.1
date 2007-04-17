Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbXDQSKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbXDQSKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161335AbXDQSKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:10:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161328AbXDQSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:10:20 -0400
Date: Tue, 17 Apr 2007 20:10:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Morris <jmorris@namei.org>
Cc: Andi Kleen <andi@firstfloor.org>, Karl MacMillan <kmacmill@redhat.com>,
       David Safford <safford@watson.ibm.com>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
Message-ID: <20070417181016.GA10903@one.firstfloor.org>
References: <20070416213350.GB4030@suse.de> <Line.LNX.4.64.0704161846110.13905@d.namei> <1176822230.3366.65.camel@localhost.localdomain> <1176825641.5946.41.camel@localhost.localdomain> <p73abx66fme.fsf@bingen.suse.de> <Line.LNX.4.64.0704171323090.19432@d.namei>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0704171323090.19432@d.namei>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 01:47:39PM -0400, James Morris wrote:
> Normal applications need zero modification under SELinux.
> 
> Some applications which manage security may need to be made SELinux-aware, 

Anything that can touch /etc/resolv.conf? That's potentially a lot of binaries
if you consider anything scripts could do with it.

> although this can often be done with PAM plugins, which is a standard way 
> to do this kind of thing in modern Unix & Linux OSs.

PAM plugins in vi and emacs? Scary idea.

And what do you do if someone decides to use OpenOffice to edit their
/etc/resolv.conf? For a lot of people that's the only text editor 
they know.

-Andi

