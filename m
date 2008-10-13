Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbYJMWCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbYJMWCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbYJMWB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:01:56 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49759 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758785AbYJMWBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:01:55 -0400
Date: Tue, 14 Oct 2008 00:01:48 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Greg KH <greg@kroah.com>
Cc: Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
Message-ID: <20081014000148.2b2632d0@i1501.lan.towertech.it>
In-Reply-To: <20081013214747.GA15765@kroah.com>
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com>
	<87prm4mbgy.fsf@hades.wkstn.nix>
	<20081013214747.GA15765@kroah.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 14:47:47 -0700
Greg KH <greg@kroah.com> wrote:

> > Major 254 is listed as LOCAL/EXPERIMENTAL USE in devices.txt. I don't
> > consider either pktcdvd or the rtc drivers as LOCAL/EXPERIMENTAL: the
> > former in particular has been in the kernel for years.  
> 
> Both of those should get "real" majors assigned to them.  It's not ok to
> randomly go grabbing major:minor numbers like this for code that is in
> mainline.

 the rtc dev uses dynamically assigned numbers, as does pktcdvd, so they
 should be able to coexist . maybe the problem lies in the pktsetup
 utility.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

