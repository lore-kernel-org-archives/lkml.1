Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbYBFNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbYBFNIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbYBFNIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:08:07 -0500
Received: from web52006.mail.re2.yahoo.com ([206.190.49.253]:43811 "HELO
	web52006.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762651AbYBFNIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:08:06 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 08:08:06 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RwpIet4/B02oZjT960oKUFYM7BF3q42qpvNXehg4yot5tI97erHmU4b/pU1dHqrXmw9dWkw02Fn7Yo+DsBCtZfj8BC6TNfs+Il5tPqWDwcXlTja0nNdE/3+d2o6fDXDAgbGMuIiPVmWf0SA9UfX1TpAm/1Us7T7EXM3IIdiQ5xQ=;
X-YMail-OSG: JlJgqbQVM1kQ13op2dx9z3Xz1_4PLmFgBgOHSxXNerXWoLNmjlj8YDJL72cbym1fMGZ_bBAB0syYqNotqNSeUJdNDrj2ffr0lyEfJHuD6vpmJSim3Z6GnC4FZfI.xwgTfYWBBptvHv_W0Qc-
Date: Wed, 6 Feb 2008 05:01:23 -0800 (PST)
From: Doug Kehn <rdkehn@yahoo.com>
Subject: Re: Soft lockup 2.6.23.14-uc0
To: linux-kernel@vger.kernel.org, uClinux <uclinux-dev@uclinux.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>
In-Reply-To: <18344.31682.388710.182172@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <478718.75314.qm@web52006.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael,

--- Mikael Pettersson wrote:


> 
> Is this a new ixp4xx platform or one of the existing
> ones in arch/arm/mach-ixp4xx?
> 

The machine type (arch/arm/tools/mach-types) is
ct_dfs.  However, the platform is a copy of the coyote
platform in arch/arm/mach-ixp4xx.


> Anyway, I can think of two things:
> 
> 1. There was some very recent patches by Peter
> Zijlstra
>    addressing hrtimer breakage on arm and some other
>    archs in 2.6.24-git. If uclinux has backported
> some
>    of that stuff then it might explain this issue.
> 
> 2. There is a new native Linux driver for ixp4xx
>    ethernet. Patches for the 2.6.23.14 kernel can
>    be found in the nslu2-linux group's subversion
>    repository. (You'll need new firmware files
> though.)
>    Replacing Intel's IXP400 drivers with this driver
>    should at least tell you if the lockups are
>    related to your use of the Intel drivers.
> 
>    FWIW, I've never seen these lockups on my ixp4xx
>    boxes, with the Intel IXP400 drivers or with
>    the new native Linux drivers.
> 
> You should also Cc: the linux arm kernel mailing
> list,
> as the issue probably is platform specific.
> 

Thanks for the tips.  I'll check in to these.

Regards,
...doug


      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
