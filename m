Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZDKTuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZDKTuu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZDKTum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:50:42 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:59966 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbZDKTul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:50:41 -0400
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/2] toshiba-acpi: Add support for hotkey notifications
Date: Sat, 11 Apr 2009 21:50:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
References: <20090331214501.GC29489@srcf.ucam.org>
In-reply-To: <20090331214501.GC29489@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904112150.38010.elendil@planet.nl>
X-OriginalArrivalTime: 11 Apr 2009 19:50:38.0344 (UTC) FILETIME=[C9887880:01C9BADE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Calling the ENAB method on Toshiba laptops results in notifications
> being sent when laptop hotkeys are pressed. This patch simply calls that
> method and sets up an input device if it's successful.

Hi Matthew,

On my Satellite A40-241 the patch works fine for the Fn keys, but it does 
not work for the multimedia keys next to the power button. No event is 
generated (I tested this by directly reading the /dev/input/eventX file).

Any chance those could be made to work too?

Cheers,
FJP
