Return-Path: <linux-kernel-owner+w=401wt.eu-S1751169AbZG3MhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbZG3MhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZG3MhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:37:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48572 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZG3MhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:37:21 -0400
Date: Thu, 30 Jul 2009 13:37:11 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, bugzilla-daemon@bugzilla.kernel.org,
       Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?C=E9dric?= Godin <cedric@belbone.be>
Subject: Re: [Bug 13865] [PATCH] hp-wmi: check that an input device exists
	in resume handler
Message-ID: <20090730123711.GB14127@srcf.ucam.org>
References: <bug-13865-10028@http.bugzilla.kernel.org/> <200907292257.41573.rjw@sisk.pl> <200907301242.07973.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907301242.07973.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 12:42:05PM +0200, Frans Pop wrote:
> From: Frans Pop <elendil@planet.nl>
> Subject: hp-wmi: check that an input device exists in resume handler
> 
> Some systems may not support input events, or registering the input
> handler may have failed. So check that an input device exists before
> trying to set the docking and tablet mode state during resume.
> 
> Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=13865
> 
> Reported-and-tested-by: Cédric Godin <cedric@belbone.be>
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
