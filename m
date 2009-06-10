Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbZFJXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbZFJXkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 19:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZFJXkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 19:40:43 -0400
Received: from xes-mad.com ([216.165.139.214]:44266 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbZFJXkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 19:40:43 -0400
Subject: Re: [PATCH next 1/2] gpio: pca953x: Get platform_data from
 OpenFirmware
From: Nate Case <ncase@xes-inc.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1244501513-19836-2-git-send-email-ncase@xes-inc.com>
References: <1244501513-19836-1-git-send-email-ncase@xes-inc.com>
	 <1244501513-19836-2-git-send-email-ncase@xes-inc.com>
Content-Type: text/plain
Organization: Extreme Engineering Solutions, Inc.
Date: Wed, 10 Jun 2009 18:40:43 -0500
Message-Id: <1244677243.29684.1615.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 17:51 -0500, Nate Case wrote:
> On OpenFirmware platforms, it makes the most sense to get
> platform_data
> from the device tree.  Make an attempt to translate OF node properties
> into platform_data struct before bailing out.
> 
> Note that the implementation approach taken differs from other device
> drivers that make use of device tree information.  This is because I2C
> chips are already registered automatically by of_i2c, so we can get by
> with a small translator function in the driver.

Hmm..  this patch doesn't show up in patchwork.  Did it get missed
somehow?

-- 
Nate Case <ncase@xes-inc.com>

