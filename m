Return-Path: <linux-kernel-owner+w=401wt.eu-S1762785AbYCGRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785AbYCGRIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYCGRIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:08:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59978 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbYCGRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:08:14 -0500
Date: Fri, 7 Mar 2008 17:08:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com, serue@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307170808.GF27894@ZenIV.linux.org.uk>
References: <47CED717.60406@openvz.org> <47CEDA64.1070506@openvz.org> <20080305171304.f686f6de.akpm@linux-foundation.org> <47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org> <47D11068.9010704@openvz.org> <20080307155921.GB28439@kroah.com> <47D16F9B.6050008@openvz.org> <20080307170104.GA24746@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307170104.GA24746@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 09:01:04AM -0800, Greg KH wrote:

> Again, I object to this as you are driving a new security policy
> infrastructure into the device node logic where it does not belong as we
> already have this functionality in the LSM interface today.  Please use
> that one instead and don't clutter up the kernel with "one-off" security
> changes like this one.
> 
> Please try the LSM interface and see what happens.  If, after you have
> created a patch, you still have objections, please post it for review
> and I will be glad to revisit my opinion at that time.

Not that per-container mappings on that level made any kind of sense in
the first place...
