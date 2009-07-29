Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZG2A2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZG2A2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZG2A2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:28:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43484 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZG2A2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:28:06 -0400
Date: Wed, 29 Jul 2009 02:28:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       kernelnewbies@nl.linux.org
Subject: Re: [PATCH] Shut off pci_find_device warnings when the deprecated
	pci functions are enabled.
Message-ID: <20090729002801.GR15310@basil.fritz.box>
References: <20090724094115.GA18450@basil.fritz.box> <20090728095552.72c41525@jbarnes-g45> <20090729001613.GA19369@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729001613.GA19369@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe it's too late now, but I thought those warnings were
> supposed to motivate people to convert old, buggy drivers to get
> off the deprecated interface.

Yes they are, but this warning instance was not for a old driver,
but for the EXPORT_SYMBOL defining the legacy function.

If any driver uses it it'll still warn.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
