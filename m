Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbZGHI44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbZGHI44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZGHI4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:56:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZGHI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:56:47 -0400
Subject: Re: Possible memory leak in request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <d82e647a0907080142q65a044aeie50048cba2ac636a@mail.gmail.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
	 <20090707190125.61920d00@gondolin>
	 <1247003445.5710.7.camel@pc1117.cambridge.arm.com>
	 <d82e647a0907072138x106c48bdyfbc4dd884ad64b2c@mail.gmail.com>
	 <1247034519.15903.3.camel@macbook.infradead.org>
	 <d82e647a0907080142q65a044aeie50048cba2ac636a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 09:56:34 +0100
Message-Id: <1247043394.25994.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 16:42 +0800, Ming Lei wrote:
> 
> IMHO, No.
> If nr_pages is not cleaned, pages pointed by pages[] will be freed
> by fw_dev_release, but they should be freed by vfree()
> in release_firmware. Right?

Yes, sorry -- you're right, and the original patch is fine.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

