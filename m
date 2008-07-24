Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYGXN0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYGXN0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYGXN0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:26:33 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:62049 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYGXN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xqbJR9DcPGW20QEbH28Vw/KnUpUhascl6pC+rTJi6IJTlzNp4FAiEPjLSALB2G94Wx
         5WbkY9n3V63pTvQ2Q/8/hY7g1U+1YUztnXVOCzDEn4POw24LYjvwetRNwice9TwJXBQt
         lIFKfxrj4V8+zVbM7ZlFP5al3xliuE9kptVsc=
Date: Thu, 24 Jul 2008 09:26:24 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
	accelerometers etc)
Message-ID: <20080724092445.ZZRA012@mailhub.coreip.homeip.net>
References: <488763AD.4050400@gmail.com> <20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net> <48887201.8090300@cam.ac.uk> <48887783.5000002@tremplin-utc.net> <4888796B.9070003@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4888796B.9070003@cam.ac.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 01:45:31PM +0100, Jonathan Cameron wrote:
> >>
> >> At the moment the big missing element of the subsystem is an easy way of
> >> querying what is there. (proc interface similar to that for the input
> >> subsystem)
> > You mean /sys/class/input/, right? Indeed, something inspired by the
> > input subsystem should work well.
> No, I meant /proc/bus/input/devices which gives machine readable description
> of all devices registered with the input subsystem and their capabilities.
> 

/proc/bus/input is a legacy interface (pre-sysfs). Newer subsystems
should try to stay in /sys/.

-- 
Dmitry
