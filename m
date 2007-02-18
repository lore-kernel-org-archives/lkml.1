Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXBRRcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXBRRcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXBRRcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:32:13 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1476 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603AbXBRRcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:32:12 -0500
Date: Sun, 18 Feb 2007 18:32:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070218183219.557856dc.khali@linux-fr.org>
In-Reply-To: <45D606A0.5020606@redhat.com>
References: <45D5EA88.7090300@redhat.com>
	<p73odntg9ga.fsf@bingen.suse.de>
	<45D606A0.5020606@redhat.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuck,

On Fri, 16 Feb 2007 14:31:44 -0500, Chuck Ebbert wrote:
> Andi Kleen wrote:
> > Chuck Ebbert wrote:
> > > So, could ACPI and the k8temp driver be at odds?
> > 
> > Yes, there is no locking between ACPI and Linux drivers for register access.
> > e.g. if there is a indexed register both try to access (and temperature
> > sensors tend to use these things) they can race and get corrupted data.
> 
> I blacklisted the k8temp driver and everything looks OK now.

You could blacklist the ACPI "thermal" module instead. If you're
interested in monitoring your CPU temperature, k8temp is IMHO more
convenient to use than ACPI, as it interfaces properly with libsensors
and all hardware monitoring user interfaces.

-- 
Jean Delvare
