Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYIMQ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYIMQ3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 12:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYIMQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 12:28:57 -0400
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:14398 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbYIMQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 12:28:56 -0400
From: Frans Pop <elendil@planet.nl>
To: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH] Fixup deb-pkg target to generate separate firmware deb.
Date: Sat, 13 Sep 2008 18:28:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20080912112042.GX30927@earth.li> <200809131035.18477.elendil@planet.nl> <20080913160831.GE30927@earth.li>
In-Reply-To: <20080913160831.GE30927@earth.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809131828.54286.elendil@planet.nl>
X-OriginalArrivalTime: 13 Sep 2008 16:28:54.0855 (UTC) FILETIME=[D08B1D70:01C915BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 September 2008, Jonathan McDowell wrote:
> Ta, I've fixed both the indents. I've also changed the firmware package
> to be arch: all.

Although I agree that arch all is technically not incorrect, I wonder if 
it is the smart thing to do it here.

The pkg-deb target is probably mostly, or even exclusively - used to build 
custom kernels, and people might be crossbuilding kernels with different 
configs and thus resulting in different firmware files from the same 
source (thus same version) on the same system.
I build amd64, i386 and armel that way on my main desktop system, all with 
different configs (tuned mainly to keep the build time down).

Keeping the firmware package arch-specific would ensure that a firmware 
package built with the config for one arch does not get overwritten by 
one built for another arch with a different config.

Cheers,
FJP
