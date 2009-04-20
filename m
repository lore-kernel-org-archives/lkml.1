Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZDTS3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZDTS3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZDTS2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:28:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37660 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZDTS2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:28:52 -0400
Date: Mon, 20 Apr 2009 19:28:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add support for Eject hotkey in dell-wmi
Message-ID: <20090420182848.GA3105@srcf.ucam.org>
References: <49ECBAE2.2080308@dell.com> <20090420182312.GA2910@srcf.ucam.org> <49ECBE35.9040003@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ECBE35.9040003@dell.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:25:57PM -0500, Mario Limonciello wrote:
> Hi Matthew:
> Matthew Garrett wrote:
> > On Mon, Apr 20, 2009 at 01:11:46PM -0500, Mario Limonciello wrote:
> >   
> >
> > Looks good - can you confirm that it'll be removed from the normal 
> > keyboard interface at the same time?
> >   
> No it won't be removed at the same time on all machines during the
> transition period.  I've however requested to add a BIOS option for the
> machines that support this to try to enable or disable WMI support in
> the interim.

Ok. How can we determine whether we're on a machine with this support? 
Applying this patch right now will result in systems receiving the event 
twice.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
