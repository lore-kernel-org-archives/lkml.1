Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYBLBOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYBLBOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYBLBOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:14:38 -0500
Received: from outbound-mail-04.bluehost.com ([69.89.21.14]:40779 "HELO
	outbound-mail-04.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759894AbYBLBOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:14:37 -0500
X-Greylist: delayed 2411 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 20:14:37 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25-rc1 regression - suspend to ram
Date: Mon, 11 Feb 2008 15:32:47 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080211225811.GB4343@ics.muni.cz> <200802120010.55021.Rafal.Wysocki@fuw.edu.pl> <20080211232213.GB8206@linux-os.sc.intel.com>
In-Reply-To: <20080211232213.GB8206@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111532.47711.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2008 3:22 pm Venki Pallipadi wrote:
> On Tue, Feb 12, 2008 at 12:10:54AM +0100, R. J. Wysocki wrote:
> > On Monday, 11 of February 2008, Lukas Hejtmanek wrote:
> > > Hello,
> >
> > Hi,
> >
> > > 2.6.25-rc1 takes really long time till it suspends (about 30-40secs,
> > > used to be about 5 secs at all) and it is resuming about few minutes. 
> > > While resuming, capslock toggles the capslock led but with few secs
> > > delay.
> > >
> > > 2.6.24-git15 was OK. 2.6.24 is OK.
> > >
> > > I have Lenovo ThinkPad T61.
> >
> > If you have CONFIG_CPU_IDLE set, please try to boot with idle=poll and
> > see if that helps.
>
> Just sent this patch to fix a regression in acpi processor_idle.c on
> another thread. Can you try the patch below and check whether that helps.

Excellent, that patch makes things work for me (including console restore).  
Thanks a lot Venki.

Jesse
