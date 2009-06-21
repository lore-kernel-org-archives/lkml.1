Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZFUHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZFUHDW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZFUHDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 03:03:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZFUHDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 03:03:12 -0400
Message-ID: <4A3DDB27.2000500@zytor.com>
Date: Sun, 21 Jun 2009 00:03:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Sean MacLennan <smaclennan@pikatech.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Badness on the Warp
References: <20090620154824.72b5cd50@lappy.seanm.ca> <200906202256.46073.elendil@planet.nl>
In-Reply-To: <200906202256.46073.elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> 
> The fact that your bisect ended at a merge essentially means that it is 
> invalid. As a merge does not introduce any actual change (unless it 
> includes changes to resolve conflicts), it normally cannot be the cause 
> of a regression.
> 

Sort of.  You can have a "bum merge" where code conflicts logically,
even if it isn't visible as a conflict in git.  Furthermore, of course,
you can have misresolved actual conflicts.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

