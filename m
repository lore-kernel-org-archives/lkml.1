Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXITMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXITMK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXITMKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:10:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXITMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:10:16 -0400
Date: Thu, 20 Sep 2007 14:10:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jesse.barnes@intel.com>,
       Howard Chu <hyc@symas.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
Message-ID: <20070920121013.GH18707@one.firstfloor.org>
References: <46EAB7DA.10507@symas.com> <200709191452.57505.jesse.barnes@intel.com> <p73d4wdal00.fsf@bingen.suse.de> <46F26208.309@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F26208.309@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there any reason not to set the MTRRs to define the entire memory as 
> write back, and use PAT exclusively for setting cacheability?

That risks breaking SMM or BIOS code.

-Andi
