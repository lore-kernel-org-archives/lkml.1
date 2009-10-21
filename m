Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZJUQDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZJUQDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZJUQDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:03:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38444 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZJUQDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:03:36 -0400
Subject: Re: [PATCH 3/5 v4] Export memory_sysdev_class
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ADF1E42.3020907@austin.ibm.com>
References: <4ADF1C49.2030201@austin.ibm.com>
	 <4ADF1E42.3020907@austin.ibm.com>
Content-Type: text/plain
Date: Wed, 21 Oct 2009 09:03:29 -0700
Message-Id: <1256141009.23737.22.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 09:44 -0500, Nathan Fontenot wrote:
> Export the memory_sysdev_class structure.  This is needed so we can create
> a 'release' file in sysfs in addition to the existing 'probe' file in
> order to support DLPAR removal of memory on the powerpc/pseries platform.
> The new 'release' file will be powerpc/pseries only.

Please do it in generic code.  You may only need it on ppc today, but
somebody else is going to want the same thing tomorrow on another arch.

It's also nice to keep all of the stuff doing the actual sysfs munging
in one place.  I know it'll cost a few stubs for calling in and out of
arch code, but it should save some work down the road for somebody else.

-- Dave

