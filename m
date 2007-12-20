Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbXLTMrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbXLTMrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbXLTMrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:47:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58594 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760094AbXLTMrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:47:20 -0500
From: Arnd Bergmann <ARNDB@de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH v4 7/8] debugfs: allow access to signed values
Date: Thu, 20 Dec 2007 13:47:13 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       hch@lst.de
References: <20071219001955.055692620@polimi.it> <1198080034.4747.15.camel@johannes.berg> <20071220131548.1d09cd62@morte>
In-Reply-To: <20071220131548.1d09cd62@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712201347.15022.ARNDB@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007, Stefano Brivio wrote:
> debugfs: allow access to signed values
> 
> Add debugfs_create_s{8,16,32,64}. For these to work properly, we need to remove
> a cast in libfs, change the simple_attr_open prototype and thus fix the users as
> well.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Mattias Nissler <mattias.nissler@gmx.de>
> To: Greg Kroah-Hartman <gregkh@suse.de>
> To: Arnd Bergmann <arndb@de.ibm.com>
> To: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

Have you checked that spufs still builds? I would guess that you need
to do the same interface changes there.

Also, Christoph has recently posted a suggestion for how to improve
the interface to allow the 'get' operation to return an error:
http://patchwork.ozlabs.org/cbe-oss-dev/patch?id=14962

I'd suggest consolidating the two changes in order to avoid merge
conflicts.

	Arnd <><
