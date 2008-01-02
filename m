Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYABWkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYABWkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYABWk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:40:27 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:14183 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYABWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:40:27 -0500
X-IronPort-AV: E=Sophos;i="4.24,236,1196661600"; 
   d="scan'208";a="469433266"
Date: Wed, 2 Jan 2008 16:40:16 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>, Adrian Bunk <bunk@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
Message-ID: <20080102224016.GA30155@auslistsprd01.us.dell.com>
References: <200801011840.38757.bzolnier@gmail.com> <1199241156.3300.55.camel@perihelion> <20080102044620.GB10762@auslistsprd01.us.dell.com> <200801022345.17529.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801022345.17529.bzolnier@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 11:45:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Unfortunately 'srcversion' is set only if MODULE_VERSION() is used... :(

or CONFIG_MODULE_SRCVERSION_ALL=y.  I see Fedora doesn't use that :-(
but Ubuntu, openSUSE do.

/me files a change request...

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
