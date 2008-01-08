Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbYAHGQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbYAHGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYAHGQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:16:48 -0500
Received: from smtprelay12.ispgateway.de ([80.67.29.29]:48830 "EHLO
	smtprelay12.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYAHGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:16:47 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: sleep before boot panic
Date: Tue, 8 Jan 2008 07:17:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Bernd Schubert <bernd-schubert@gmx.de>, linux-kernel@vger.kernel.org
References: <200801061908.43010.bernd-schubert@gmx.de> <p731w8ts70k.fsf@bingen.suse.de>
In-Reply-To: <p731w8ts70k.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801080717.03467.ioe-lkml@rameria.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008, Andi Kleen wrote:
> Bernd Schubert <bernd-schubert@gmx.de> writes:
> 
> > Hi,
> >
> > I just switched to libata (pata) on my laptop and the immediate panic made it 
> > impossible to figure out why my boot partition wasn't available.
> > After applying this little patch I could check boot printk output and then saw 
> > everything was properly recognized and only scsi-disk support was missing.
> 
> The correct fix would be to make scroll back (and sysrq) still work
> after panic.  It's a little more complicated, but possible (essentially
> it needs a polled keyboard handler)

Customer: "This system could not find the root fs."
Support: "Oh, yeah, just connect a (USB-) keyboard and scroll back."

Hmm, device detection works after panic?

I really like the "soft" panic better, where you still can operate the 
kernel debugging features, but just have no user space supporting it.

One better hopes, that keyboards never need external firmware to be loaded
at this stage :-)

Best Regards

Ingo Oeser, who just hit the same problem yesterday...
