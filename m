Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068Ab0AHVYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0AHVYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909Ab0AHVYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:24:09 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:60480 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752273Ab0AHVYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:24:07 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] drivers/gpu/drm/i915/i915_debugfs.c: remove unnecessary casts
Date: Fri, 8 Jan 2010 16:24:02 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090208974B@mi8nycmail19.Mi8.com>
In-Reply-To: <20100108132049.27e4b1cf@jbarnes-piketon>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/gpu/drm/i915/i915_debugfs.c: remove unnecessary casts
Thread-Index: AcqQqHKHTaAf24tCQdO/P8Gmw5tmEQAAC4Gw
References: <201001081418.01471.hartleys@visionengravers.com> <20100108132049.27e4b1cf@jbarnes-piketon>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       <dri-devel@lists.sourceforge.net>, <airlied@linux.ie>
X-OriginalArrivalTime: 08 Jan 2010 21:24:02.0924 (UTC) FILETIME=[E67B82C0:01CA90A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 08, 2010 2:21 PM, Jesse Barnes wrote:
> On Fri, 8 Jan 2010 14:18:01 -0700
> H Hartley Sweeten <hartleys@visionengravers.com> wrote:
>
>> drivers/gpu/drm/i915/i915_debugfs.c: Remove unnecessary casts.
>> 
>> The struct seq_file 'private' member is a void *, the casts are not
>> needed.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: David Airlie <airlied@linux.ie>
>
> This one should go to Eric Anholt <eric@anholt.net>, and why not just
> do a full "drm/i915: remove unnecessary casts" patch all at once?  That
> would probably be easier for Eric.

Yah, I just noticed there are a number of them in drivers/gpu/drm/*.

Can Eric Anholt handle all of them or just the i915 specific ones?

Thanks,
Hartley
