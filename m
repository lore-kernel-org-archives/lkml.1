Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab0BYXXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:23:49 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:36352 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934253Ab0BYXXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:23:47 -0500
Date: Fri, 26 Feb 2010 00:23:45 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       dan.j.williams@intel.com
Subject: Re: Buggy variable-length array code...or compiler?
Message-ID: <20100225232345.GA16671@const.homenet.telecomitalia.it>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Steven J. Magnani" <steve@digidescorp.com>,
	linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
	dan.j.williams@intel.com
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267139849.3079.68.camel@iscandar.digidescorp.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIRC C99 allows VLAs to not be freed immediately, but at function
termination, which makes things way simpler to implement for compilers.
I've noticed it on Solaris and cell's spugcc.

Steven J. Magnani, le Thu 25 Feb 2010 17:17:29 -0600, a écrit :
> 1. There is a coding error in dmatest

It needs to get out of the function from times to times to free the
VLAs.

> 2. There is a bug specific to Microblaze gcc compiler(s) [mine is 4.1.2]
> 3. There is a bug generic to specific versions of gcc compilers
> 4. There is a bug generic to all gcc compilers

I've usually seen gcc free VLAs as soon as possible, so I believe it's
only a few targets.

Samuel
