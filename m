Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbYBKVFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbYBKVFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYBKVFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:05:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:49529 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYBKVFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:05:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WCu/AHl0xNJzstDLEp9lZCO6nyJCeYIWRMRUoA/R+Aj0MepTTPsg7OKgpJCuLl1U7aJjU/yfh10oqlcl6MiGulLnCp20eU/WB9VvdaT6vFVggQPPYrkB5QYWwwwmk5uuPK0/2mtwJ388dWJ0ICb16NXq+hhpIALntTPtkOJ/388=
Subject: Re: [PATCH] Remove CONFIG_FORCE_INLINING from defconfigs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080211205311.GD2959@cs181133002.pp.htv.fi>
References: <1202761747.10004.11.camel@brick>
	 <20080211205311.GD2959@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 13:05:02 -0800
Message-Id: <1202763902.10004.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 22:53 +0200, Adrian Bunk wrote:
> On Mon, Feb 11, 2008 at 12:29:06PM -0800, Harvey Harrison wrote:
> > Option has been removed as of:
> > 185c045c245f46485ad8bbd8cc1100e986ff3f13 x86, core: remove CONFIG_FORCED_INLINING
> >...
> 
> I'm not a fan of patching defconfig's this way - this will only bring 
> tons of patch conflicts (consider what happens when anyone already has
> a completely updated defconfig in his tree and your patch goes in first).
> 

OK, I just figured it was my patch that went in removing it, so I should
submit a full-removal for completeness.  If it will just cause problems,
no need for it to be applied.

Harvey

