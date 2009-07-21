Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZGUIcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZGUIcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZGUIcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:32:11 -0400
Received: from ns.firmix.at ([62.141.48.66]:3301 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZGUIcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:32:10 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 04:32:10 EDT
Subject: Re: [patch 27/54] Staging: hv: remove ULONG and LONG typedefs
From: Bernd Petrovitsch <bernd@firmix.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, devel@driverdev.osuosl.org,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, Sam Ramji <sramji@microsoft.com>,
       shemminger@linux-foundation.org
In-Reply-To: <200907210200.16295.arnd@arndb.de>
References: <20090717180850.873962925@mini.kroah.org>
	 <20090717180920.285605541@mini.kroah.org>
	 <200907210200.16295.arnd@arndb.de>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 21 Jul 2009 10:26:11 +0200
Message-Id: <1248164771.16364.7.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.276 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.276 required=5
X-Spam-Score: -2.276 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 02:00 +0200, Arnd Bergmann wrote:
> On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > The ULONG and LONG typedefs are now removed from the Hyper-V driver
> > code
> 
> This conversion is not equivalent:
[...]
> - // redefine the world, because we can
[...]
> - #define FALSE (2)
That has been done already by the SNMP folks - see
http://www.faqs.org/rfcs/rfc1903.html under "TruthValue".
S,CNR and for off-topic ...

> ;-)
;-) either ....

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


