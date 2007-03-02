Return-Path: <linux-kernel-owner+w=401wt.eu-S2992780AbXCCADN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992780AbXCCADN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992781AbXCCADN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:03:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:44917 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992780AbXCCADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:03:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,244,1170662400"; 
   d="scan'208"; a="206146772:sNHT22093120"
Subject: Re: system call time increase when turning on CONFIG_PARAVIRT
From: Tim Chen <tim.c.chen@linux.intel.com>
Reply-To: tim.c.chen@linux.intel.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45E89CFB.4090905@goop.org>
References: <1172866274.4898.14.camel@localhost.localdomain>
	 <45E89CFB.4090905@goop.org>
Content-Type: text/plain
Organization: Intel
Date: Fri, 02 Mar 2007 15:11:51 -0800
Message-Id: <1172877111.8383.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 13:54 -0800, Jeremy Fitzhardinge wrote:

> [ I assume you're talking about running on native hardware. ]
> 
That's correct.

> I haven't done any detailed measurements on what effect this will have,
> but it does bring the actual executed instruction stream much closer to
> the !CONFIG_PARAVIRT case, and so I would hope it would recover most or
> all of the performance loss you've noticed.
> 
I also hope that the performance can be recovered as this option could
enabled in distributions' kernels in future.

Tim
