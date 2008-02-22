Return-Path: <linux-kernel-owner+w=401wt.eu-S935552AbYBVAmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552AbYBVAmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbYBVAmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:42:21 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:58383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbYBVAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CHnEgP5ice9RYitZUBZpqaIAa3vBncGRZV2k6y9rs39vD0Zau12Zy1Jzmu8OFfe0zjGQlMg92ezgpwBimSdo9zBcoGqtmtNeV63V/Au1/kw+roxakkClkSzKiud7QX09Suhg95AaWQsPYLTVl+yX6RL+knochAwnA5NLBRQ+t68=
Message-ID: <b6a2187b0802211642i17730ccav6744b614c086df72@mail.gmail.com>
Date: Fri, 22 Feb 2008 08:42:15 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802211623.55450.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802211302.27002.jesse.barnes@intel.com>
	 <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
	 <200802211623.55450.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 8:23 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:

>  Your system (either your distro suspend/resume scripts or your platform) must
>  be running the video BIOS at resume time, otherwise it would probably come
>  back blank.

But I don't think so, unless acpid is doing just that. In my
suspend/resume event script, it's just doing a simple s2ram (without
options), and exit after resume.

Jeff.
