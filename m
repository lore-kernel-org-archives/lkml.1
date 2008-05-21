Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbYEUGtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbYEUGtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbYEUGtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:49:03 -0400
Received: from mga06.intel.com ([134.134.136.21]:57821 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756377AbYEUGtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:49:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,519,1204531200"; 
   d="scan'208";a="283478483"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Date: Tue, 20 May 2008 23:48:38 -0700
User-Agent: KMail/1.9.9
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805202035.20529.inaky@linux.intel.com> <20080521034213.GE26427@khazad-dum.debian.net>
In-Reply-To: <20080521034213.GE26427@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805202348.39807.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 20 May 2008, Inaky Perez-Gonzalez wrote:
> > > Stuff like "WiMax", "802.1a", "EDGE", "GRPS", "802.1bg" would be the
> > > type, and class would be "WLAN", "WWAN", etc.
> > > 
> > > We would only deal with classes on rfkill-input.  Anything else more
> > > specific should be done in userspace instead, disabling rfkill-input.
> > 
> > How would this apply to the case where I want to use the HW key to switch
> > one off and turn the other one off (say I have both a WiMAX and EDGE
> > cards in my machine); how could we do it to distinguish which key is which?
> > I might be missing something.
> 
> I don't understand.  Switch one off and turn the other one off?  Isn't
> that the same thing?

-EOPERATORISDUMB, sorry; I meant turn one off and the other on. 

-- 
Inaky
