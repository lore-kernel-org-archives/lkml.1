Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0CEHur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:50:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51023 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0CEHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:50:46 -0500
Subject: Re: [PATCH] drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell
 Inspiron 700m
From: Surbhi Palande <Surbhi.Palande@canonical.com>
Reply-To: Surbhi.Palande@canonical.com
To: Eric Anholt <eric@anholt.net>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       airlied@linux.ie, yakui.zhao@intel.com, jbarnes@virtuousgeek.org,
       airlied@redhat.com, zhenyuw@linux.intel.com
In-Reply-To: <87lje9ou77.fsf@pollan.anholt.net>
References: <1267563592-6614-1-git-send-email-surbhi.palande@canonical.com>
	 <87lje9ou77.fsf@pollan.anholt.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Canonical Pvt. Ltd.
Date: Fri, 05 Mar 2010 09:50:34 +0200
Message-ID: <1267775434.2065.7.camel@subu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, 2010-03-03 at 15:34 -0800, Eric Anholt wrote:
> On Tue,  2 Mar 2010 22:59:52 +0200, Surbhi Palande <surbhi.palande@canonical.com> wrote:
> > BugLink: https://bugs.launchpad.net/bugs/515246
> > 
> > Sony VGN-BX196VP and Dell Inspiron 700m report lid status as closed
> > when it is open. This leads to a "no connectors reported" error at startup.
> > Blacklisting them, to always return a connected status for the default
> > lvds connector.
> > 
> > Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
> 
> As far as I know, this should already be covered by:
> 
> commit 7b9c5abee98c54f85bcc04bd4d7ec8d5094c73f4
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Fri Feb 12 09:30:00 2010 -0800
> 
>     drm/i915: give up on 8xx lid status

Yes I agree. Thanks for the comment.

However, the "drm/i915: give up on 8xx lid status" will work for the
Dell Inspiron 700m. But, the Sony VGN-BX196VP will still need to be
blacklisted as it is a 915GM device.

If you agree with this, I will rewrite the patch and send you another
version.

Thanks!

Warm Regards,
Surbhi.

