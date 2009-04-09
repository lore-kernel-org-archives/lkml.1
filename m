Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbZDIPcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbZDIPcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbZDIPcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:32:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60309 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZDIPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:32:11 -0400
Date: Thu, 9 Apr 2009 16:32:03 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Additional keys for dell-wmi
Message-ID: <20090409153203.GB17194@srcf.ucam.org>
References: <200904082116.n38LG4Df012420@ampersand.seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904082116.n38LG4Df012420@ampersand.seas.upenn.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 05:16:04PM -0400, Rafi Rubin wrote:

>  static struct key_entry dell_wmi_keymap[] = {
>  	{KE_KEY, 0xe045, KEY_PROG1},
> +	{KE_KEY, 0xe046, KEY_PROG2},
> +	{KE_KEY, 0xe047, KEY_PROG3},

Would this make more sense as a switch? That way userspace can know what 
state the screen is in.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
