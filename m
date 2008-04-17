Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYDQUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYDQUJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYDQUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:09:03 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:34351 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753045AbYDQUJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:09:01 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Thu, 17 Apr 2008 13:08:36 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Reuben Farrelly <reuben-lkml@reub.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de>
In-Reply-To: <200804172140.02311.jdelvare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804171308.37328.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 216.239.45.19 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 17, 2008 12:40 pm Jean Delvare wrote:
> Booting with "nosmp" doesn't work on my Thinkpad T60p laptop while
> booting with "nosmp pci=nomsi" works. Forcibly disabling PCI MSI
> when booting with nosmp fixes the problem. I'm not sure if it's the
> correct fix though.

Seems like this is fixing the symptom, not the cause.  I'll see if I can 
reproduce locally...

Jesse
