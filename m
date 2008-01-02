Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYABJb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYABJb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYABJbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:31:49 -0500
Received: from ns.firmix.at ([62.141.48.66]:3681 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbYABJbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:31:48 -0500
Subject: Re: Get physical MAC address
From: Bernd Petrovitsch <bernd@firmix.at>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Theewara Vorakosit <thvo@hpcnc.cpe.ku.ac.th>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
In-Reply-To: <20080102045800.GC10762@auslistsprd01.us.dell.com>
References: <Pine.LNX.4.44.0712311233290.17732-100000@hpcnc.cpe.ku.ac.th>
	 <20080102045800.GC10762@auslistsprd01.us.dell.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 02 Jan 2008 10:31:25 +0100
Message-Id: <1199266285.30753.14.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.332 required=5
X-Spam-Score: -2.332 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2008-01-01 at 22:58 -0600, Matt Domsch wrote:
> On Mon, Dec 31, 2007 at 12:39:11PM +0700, Theewara Vorakosit wrote:
> > Hello,
> > 
> > I get MAC address from ioctl. However, ifconfig can change this  MAC 
> > address. Can I get a real physical MAC address of the NIC?
> 
> yes.  It's ETHTOOL_GPERMADDR to the ethtool ioctl.
> 
>         case ETHTOOL_GPERMADDR:
>                 rc = ethtool_get_perm_addr(dev, useraddr);
>                 break;
> 
> When the driver is first loaded, before ifconfig can change the MAC
> address, the existing (permanent) MAC address is stored away, able to
> be retrieved via this ioctl.  Jon Wetzel, a Dell intern of a few
> summers ago, wrote the code and was able to have it included.

I stand corrected.
Last time I looked for such a thing it didn't exist.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


