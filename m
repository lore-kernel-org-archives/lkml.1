Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbZHRQYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbZHRQYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZHRQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:24:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58092 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbZHRQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:24:05 -0400
Date: Tue, 18 Aug 2009 09:24:05 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, rui.zhang@intel.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] acpi_power_meter: hwmon driver for ACPI 4.0 power
	meters
Message-ID: <20090818162405.GB10233@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004335.20709.52288.stgit@elm3a70.beaverton.ibm.com> <alpine.LFD.2.00.0907272124110.4445@localhost.localdomain> <20090803205812.GC14694@plum> <20090806204255.GD14694@plum> <20090817150558.3468426b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817150558.3468426b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 03:05:58PM -0700, Andrew Morton wrote:
> > +	if (ACPI_FAILURE(status)) {
> > +		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PAI"));
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (data)
> > +		return -EINVAL;
> 
> I find this test of `data' inexplicable.  Is it just me, or do we need
> a comment here?

ACPI spec says that the _PAI method passes back 0 on success.  I guess I'll
reroll the patch with a comment stating that.

> > +	if (ACPI_FAILURE(status)) {
> > +		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _SHL"));
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (data)
> > +		return -EINVAL;
> 
> ditto.

Ditto.

--D
