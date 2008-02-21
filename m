Return-Path: <linux-kernel-owner+w=401wt.eu-S934961AbYBUAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961AbYBUAS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 19:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYBUASM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 19:18:12 -0500
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:33403 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754372AbYBUASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 19:18:10 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Date: Wed, 20 Feb 2008 16:17:51 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201534.36174.jbarnes@virtuousgeek.org> <200802210049.42820.rjw@sisk.pl>
In-Reply-To: <200802210049.42820.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201617.51387.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2008 3:49 pm Rafael J. Wysocki wrote:
> > And just to confirm that, I just tested the current DRM modules against a
> > 2.6.23.15 kernel.
>
> In 2.6.23.x there's no second ->suspend() during hibernation, so no wonder.

In 2.6.23 it's just:
  ->suspend()
  ->resume()
  *S4*
?

I ask because we still do the D3hot call in the DRM tree, so the hang should 
still occur unless the PM or ACPI core has changed.

> I'll figure out how to work around this issue in the current mainline, but
> a real fix will only be possible when we have separate callbacks for
> hibernation.

Ok, thanks.

Jesse
