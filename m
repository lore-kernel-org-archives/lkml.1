Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYJPTLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYJPTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756529AbYJPTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:11:10 -0400
Received: from solo.fdn.fr ([80.67.169.19]:45019 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbYJPTLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:11:09 -0400
Date: Thu, 16 Oct 2008 21:11:06 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use PC-BIOS NUMLOCK flag
Message-ID: <20081016191106.GB4988@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
References: <alpine.LSU.0.999.0810161358540.5404@be1.lrz> <20081016143856.GD5071@const.bordeaux.inria.fr> <alpine.LSU.0.999.0810161958450.5051@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.0.999.0810161958450.5051@be1.lrz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert, le Thu 16 Oct 2008 20:00:31 +0200, a écrit :
> On Thu, 16 Oct 2008, Samuel Thibault wrote:
> > Bodo Eggert, le Thu 16 Oct 2008 13:59:49 +0200, a écrit :
> 
> > > +	  If you have an alternative firmware like OpenFirmware or LinuxBios,
> > > +	  this flag might not be set correctly, which results in a random state
> > > +	  of the Numlock key.
> > 
> > That's an issue. That means that distributions will just not enable,
> > and thus the flag is not really useful, since people who would
> > compile their own kernel would very likely have already setup their
> > initialization scripts into calling setleds +num (or just set LEDS=+num
> > in /etc/console-tools/config on a debian machine).
> 
> I hope somebody will pop up and say "Hey, those will create an IBM PC data 
> area, because they run DOS" ...

Mmm, or rather "hey, here are the patches to fix those BIOSes" :)

Samuel
