Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZA2DVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZA2DVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 22:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZA2DVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 22:21:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbZA2DVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 22:21:00 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH revised] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Wed, 28 Jan 2009 22:20:48 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@bitplanet.net>,
       linux-kernel@vger.kernel.org
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <200901281725.25750.jarod@redhat.com> <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a24a8ff6f4c5711f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282220.49103.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009 18:11:59 Stefan Richter wrote:
> According to https://bugs.launchpad.net/bugs/294391
>   - 3rd generation iPods need the "fix capacity" workaround after all
>     (apparently they crash after the last sector was accessed),
>   - 2nd generation iPods need the "128 kB maximum request size"
>     workaround.
>
> Alas both iPod generations feature the same model ID in the config ROM,
> hence we can only define a shared quirks list entry for them.  Luckily
> the fix capacity workaround did not show a negative effect in Jarod's
> tests with 2nd gen. iPod.
>
> A side note:  Apple computers in target mode (or at least an x86 Mac
> mini) don't have firmware_version and model_id, hence none of the iPod
> quirks list entries is active for them.
>
> Tested-by: Jarod Wilson <jarod@redhat.com>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Looks golden to me, and I've wedged this into the latest Fedora rawhide
kernels. Go 'head and add this too:

Acked-by: Jarod Wilson <jarod@redhat.com>

Thanks much!

-- 
Jarod Wilson
jarod@redhat.com

