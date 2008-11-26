Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYKZPU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYKZPU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKZPUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:20:13 -0500
Received: from sous-sol.org ([216.99.217.87]:51748 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752167AbYKZPUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:20:11 -0500
Date: Wed, 26 Nov 2008 07:19:40 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Chris Wright <chrisw@sous-sol.org>, jbarnes@virtuousgeek.org,
       greg@kroah.com, miltonm@bga.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       allen.m.kay@intel.com, jun.nakajima@intel.com
Subject: Re: [PATCH 1/2] PCI: allow pci driver to support only dynids
Message-ID: <20081126151940.GA16132@sequoia.sous-sol.org>
References: <20081126033610.GB19881@sequoia.sous-sol.org> <20081126092808.48519dcb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126092808.48519dcb@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean Delvare (khali@linux-fr.org) wrote:
> As a side note, I am curious what PCI driver we do have which has
> driver->probe defined but no driver->id_table. Did you hit an actual
> issue or are you fixing a theoretical one?

Such a driver was patch 2/2.

http://lkml.org/lkml/2008/11/26/11

It's meant to have only dynamic ids, worked fine on 2.6.27 and oopsed
from NULL id-> deref on current git.

thanks,
-chris
