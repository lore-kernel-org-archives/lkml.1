Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZJCPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZJCPN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 11:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZJCPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 11:13:26 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:58441 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZJCPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 11:13:25 -0400
Date: Sat, 3 Oct 2009 18:12:43 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: How to disable drm/kms actions during boot?
Message-ID: <20091003151243.GG32486@mea-ext.zmailer.org>
References: <20091003121958.GD32486@mea-ext.zmailer.org> <a728f9f90910030738q4341611fm4ccd680b51201f6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a728f9f90910030738q4341611fm4ccd680b51201f6d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 10:38:12AM -0400, Alex Deucher wrote:
> From: Alex Deucher <alexdeucher@gmail.com>
> 
> On Sat, Oct 3, 2009 at 8:19 AM, Matti Aarnio <matti.aarnio@zmailer.org> wrote:
> > I have a display card + display combination that has recently had much problems
> > during system boot.  Some system versions boot just fine to very large text mode,
> > others create entirely black display.
> >
> > Is there any way to forbid the DRM from doing "maximize the text display area"
> > operation at all during the boot?  I do want the DRM/KMS to happen latter, but
> > NOT during system boot!
> 
> Boot with nomodeset or radeon.modeset=0 on the kernel command line.
> That will disable kernel modesetting at boot.  You can then manually
> load the modules with or without modesetting once the system is
> booted.  drm-next also recently got support for forcing the console
> mode.

Thanks, that saved the day.  The kernel boots to text console just fine, and when
I am happy, log in as my non-privileged self and start X, firmware loading and mode
settings are working correctly.

Of course I would be happier without these boot commandline extras, so
current Fedora 12 (Beta) kernel has some bad radeon drm/dri/kms bits on it.
Couple of weeks ago things did work just fine with modesetting happening
early in the boot.  Four weeks ago things failed, and six weeks ago this
modesetting thing did not exist...

Current kernel is:
  2.6.31.1-56.fc12.x86_64 #1 SMP

> Alex

/Matti Aarnio
