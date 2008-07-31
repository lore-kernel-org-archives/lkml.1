Return-Path: <linux-kernel-owner+w=401wt.eu-S1758876AbYGaVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876AbYGaVrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYGaVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:47:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57393 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbYGaVr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:47:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
Subject: Re: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Date: Thu, 31 Jul 2008 23:49:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20080731210507.GA6094@denkbrett.schottelius.org>
In-Reply-To: <20080731210507.GA6094@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807312349.47817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 of July 2008, Nico Schottelius wrote:
> Hello¡
> 
> I've some serious problems with this kernel on the ibm t60:
> 
> - wake up from suspend takes about 30 seconds
> - i need to switch to console and back to see xorg screen again (before:
>   only black)
> - after wake up, I get disk input/output errors, no access to sda is
>   possible
> 
> As I could not do any dumps I took photos of the dmesg output with my
> camera and put them in high resolution to
> 
>    http://home.schottelius.org/~nico/unix/linux/kernel/2.6.27-rc1-00156-g94ad374/

Can you test the fix in http://bugzilla.kernel.org/show_bug.cgi?id=11178, please?

Thanks,
Rafael
