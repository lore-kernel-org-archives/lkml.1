Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbXGANDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbXGANDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 09:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbXGANC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 09:02:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54884 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbXGANC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 09:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dcE2713bHpxKEH49zsNhdmzxUIaPuD1UkySOTSLgTBndOTP9V81nwdvIGTspFjDR2u46NOjF7xwg7I8uSUZIjGHbzbps7LQbRJcNAdl4qzcNoe3nZGUA2xC83vy0nqB1pVknbiVMlY92R+WW+pwtmYQ5y79IAYqTsCQlFjfTBeo=
Message-ID: <4354d3270707010602p542512aex678b27217c0b2cb2@mail.gmail.com>
Date: Sun, 1 Jul 2007 16:02:56 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] b44: power down PHY when interface down
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, netdev@vger.kernel.org,
       power@bughost.org, zambrano@broadcom.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070630151923.GA22983@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com>
	 <20070630120541.GA21339@srcf.ucam.org>
	 <46866C6B.9010801@linux.intel.com>
	 <20070630151923.GA22983@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Jun 30, 2007 at 07:44:59AM -0700, Arjan van de Ven wrote:
> > Matthew Garrett wrote:
> > >Do you still get link beat detection when the phy is powered down?

No.
As for link detection on the switch connected to this card:
If I have WoL turned off, then I don't get link beat detection.
If I have WoL turned on, then PHY won't be powered down, and I get
link detection on the switch.

> > >
> > does that matter?
> > If the interface is down, nic drivers aren't expected to detect
> > link... if userspace wants to find link status it should have the
> > interface up.

I don't get link beat detection with the original driver either, when
interface is down
(unless I pass it -a, but then it will bring the interface up).


--Edwin
