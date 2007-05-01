Return-Path: <linux-kernel-owner+w=401wt.eu-S1946023AbXEAVEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbXEAVEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946029AbXEAVET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:04:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33698 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbXEAVES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:04:18 -0400
Date: Tue, 1 May 2007 23:05:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Andrew Morton <akpm@osdl.org>, azarah@nosferatu.za.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Propagate errors from find in scripts/gen_initramfs_list.sh
Message-ID: <20070501210510.GA32547@uranus.ravnborg.org>
References: <20070430053440.8BC3FDDF7A@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430053440.8BC3FDDF7A@ozlabs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 03:34:15PM +1000, Michael Ellerman wrote:
> If the find(1) in scripts/gen_initramfs_list.sh generates any errors, it
> will cause gen_initramfs_list.sh to fail (because of "set -e"), however
> the errors from find are not printed to the user. This is rather confusing:

Agree - patch applied.

	Sam
