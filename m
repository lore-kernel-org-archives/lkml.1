Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZIIV3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZIIV3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZIIV3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:29:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35816 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbZIIV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:29:32 -0400
Date: Wed, 9 Sep 2009 23:29:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>, rui.zhang@intel.com,
       lenb@kernel.org
Subject: Re: [PATCH v4] hwmon driver for ACPI 4.0 power meters
Message-ID: <20090909212928.GB7248@elf.ucw.cz>
References: <200908202049.n7KKnKO7015060@imap1.linux-foundation.org> <20090820211557.GA8431@elf.ucw.cz> <20090820213755.GB10521@tux1.beaverton.ibm.com> <20090821091939.GC21167@elf.ucw.cz> <20090821184718.GD23397@tux1.beaverton.ibm.com> <20090821221705.GA2108@elf.ucw.cz> <20090822011744.GH10521@tux1.beaverton.ibm.com> <20090821140159.GB1328@ucw.cz> <20090908202410.GS10521@tux1.beaverton.ibm.com> <20090909182347.GB26158@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909182347.GB26158@tux1.beaverton.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config ACPI_POWER_METER
> +	tristate "ACPI 4.0 power meter"
> +	depends on HWMON
> +	default y

Should not really be default y, see the other mail.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
