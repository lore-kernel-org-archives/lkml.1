Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYJANbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYJANbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYJANb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:31:27 -0400
Received: from twin.jikos.cz ([213.151.79.26]:40139 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYJANb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:31:27 -0400
Date: Wed, 1 Oct 2008 15:29:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
       "kkeil@suse.de" <kkeil@suse.de>,
       "agospoda@redhat.com" <agospoda@redhat.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Graham, David" <david.graham@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "chris.jones@canonical.com" <chris.jones@canonical.com>,
       "tim.gardner@intel.com" <tim.gardner@intel.com>,
       "airlied@gmail.com" <airlied@gmail.com>, Olaf Kirch <okir@suse.cz>
Subject: RE: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
In-Reply-To: <B27EBC40D200ED48A3F4CC2EBEABAE0B157C500E@orsmsx501.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0810011528180.2307@twin.jikos.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
 <Pine.LNX.4.64.0809301439021.2307@twin.jikos.cz>
 <B27EBC40D200ED48A3F4CC2EBEABAE0B157C500E@orsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008, Allan, Bruce W wrote:

> Yeah, we can do that.  I need to amend the patch a bit to prevent the 
> protected range lock from being lifted unintentionally and will add some 
> debug statements if/when any write/erase cycles fail.

Olaf raised a rather interesting question -- would iAMT be able to access 
NVM contents directly, even if the lock bit would be set on the device? 
I.e. is iAMT allowed direct access to the EEPROM contents, bypassing 
shadow ram mappings?

Thanks,

-- 
Jiri Kosina
SUSE Labs

