Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZLUIPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZLUIPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZLUIPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:15:53 -0500
Received: from isilmar.linta.de ([213.133.102.198]:57974 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260AbZLUIPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:15:52 -0500
Date: Mon, 21 Dec 2009 09:15:50 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alex Chiang <achiang@hp.com>
Cc: venkatesh.pallipadi@intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] ACPI: early _PDC eval and unify x86/ia64
Message-ID: <20091221081550.GA1648@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alex Chiang <achiang@hp.com>, venkatesh.pallipadi@intel.com,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091220190434.4274.67855.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Dec 20, 2009 at 12:19:04PM -0700, Alex Chiang wrote:
> This does introduce a boot time namespace walk for all the CPUs
> in the system, looking for and evaluating _PDC. Hopefully that
> will not make life miserable for the giant SGI clusters. If worse
> comes to worse, maybe we can quirk them and avoid the namespace
> walk.

Could this be done async, with completion before EC initialization?

Best,
	Dominik
