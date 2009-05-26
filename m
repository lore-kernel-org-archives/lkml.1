Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZEZTQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZEZTQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZEZTPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:15:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37562 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbZEZTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:15:40 -0400
Date: Tue, 26 May 2009 21:04:16 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/6] firmware: dynamic firmware id allocation
Message-ID: <20090526190415.GA3500@tuxdriver.com>
References: <20090526174012.423883376@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526174012.423883376@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 07:40:12PM +0200, Samuel Ortiz wrote:

> This 6 patches patch set allows for a removal of the firmware name length
> restriction from the firmware class API.
> Currently we're limited to 30 characters for firmware names because of a
> statically allocated 30 bytes string in the firmware class code. We also want
> to remove the FIRMWARE_NAME_MAX definition to prevent future drivers from
> referencing it.
> 
> Patch #1 removes that restriction by dynamically allocating the firmware id.
> Patches #2,3,4,5 remove all FIRMWARE_NAME_MAX references from the kernel code.
> Patch #6 gets rid of the FIRMWARE_NAME_MAX definition, and should be applied
> only once all previous patches from this patch set are applied.

You probably want to include "libertas: adapt for dynamic firmware
id allocation" in this series... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
