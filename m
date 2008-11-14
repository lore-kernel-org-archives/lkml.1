Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYKNRNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYKNRNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYKNRMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:12:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48777 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYKNRMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:12:54 -0500
Date: Fri, 14 Nov 2008 17:12:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081114171252.GA29056@srcf.ucam.org>
References: <49105BA6.9090403@tuffmail.co.uk> <20081104143332.GA21689@srcf.ucam.org> <491063B3.4080808@tuffmail.co.uk> <20081104151128.GA22544@srcf.ucam.org> <49106DD7.9010307@tuffmail.co.uk> <20081104155722.GA23314@srcf.ucam.org> <491076BD.1030704@tuffmail.co.uk> <49170B16.4010909@tuffmail.co.uk> <20081114161631.GA28234@srcf.ucam.org> <491DB048.3090308@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491DB048.3090308@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 05:07:20PM +0000, Alan Jenkins wrote:

> Note that Xandros say the newest model EeePC (S101) 'is now using a
> "normal" kill of the antenna, which is easier to work with'.

Well, it would have been nice of them to try to solve the problem 
properly rather than jumping through hoops.

> So if you're unlucky, the current eeepc-laptop worked perfectly on the
> S101, and now it will simply refuse to load :).  But it's probably safer
> that way.  At least the 701 runs quite adequately without eeepc-laptop. 
> I guess it can be fixed when someone interested gets their hands on an S101.

Failing to register the notify handler isn't a fatal error, so shouldn't 
be an issue. It would be nice to see how it behaves in that case, 
though. If anyone's got an S101 I'd be interested in an ACPI dump.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
