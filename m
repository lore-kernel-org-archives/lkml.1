Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689Ab0AUJGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab0AUJGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037Ab0AUJGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:06:32 -0500
Received: from isilmar.linta.de ([213.133.102.198]:56478 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398Ab0AUJGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:06:30 -0500
Date: Thu, 21 Jan 2010 10:02:36 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Mike Chan <mike@android.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Miller@fmi.uni-stuttgart.de, tj@kernel.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de, davej@redhat.com
Subject: Re: [PATCH 2/2] cpufreq: ondemand: Replace ignore_nice_load with
 nice_max_freq
Message-ID: <20100121090236.GA23891@dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Mike Chan <mike@android.com>, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org, Miller@fmi.uni-stuttgart.de,
	tj@kernel.org, venkatesh.pallipadi@intel.com, trenn@suse.de,
	davej@redhat.com
References: <1264043737-2505-1-git-send-email-mike@android.com>
 <1264043737-2505-2-git-send-email-mike@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264043737-2505-2-git-send-email-mike@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jan 20, 2010 at 07:15:37PM -0800, Mike Chan wrote:
> **Note: ingore_nice_load has been removed since the same functionality
> can be achieved by setting nice_max_freq to scaling_min_freq.

Couldn't we keep "ignore_nice_load" as deprecated sysfs file (with a printk
warning) for one or two releases, as this breaks some userspace scripts?

Best,
	Dominik
