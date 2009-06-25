Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZFYPmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZFYPmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZFYPmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:42:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49524 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZFYPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:42:24 -0400
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
	driver
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Alek Du <alek.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
In-Reply-To: <20090625230949.53beda65@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	 <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	 <20090625210642.432e08a5@dxy.sh.intel.com>
	 <1245936693.20530.107.camel@jani-desktop>
	 <20090625220826.1fa7413e@dxy.sh.intel.com>
	 <1245941565.20530.134.camel@jani-desktop>
	 <1245942355.20530.141.camel@jani-desktop>
	 <20090625230949.53beda65@dxy.sh.intel.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 18:42:08 +0300
Message-Id: <1245944528.20530.145.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 15:42:13.0923 (UTC) FILETIME=[82C98F30:01C9F5AB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 17:09 +0200, ext Alek Du wrote:
> On Thu, 25 Jun 2009 23:05:55 +0800
> Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> > Actually scrap that, the input layer already ignores events with no
> > state changes, right?
> > 
> Yes, correct. I just want to reply your previous mail, but seems you find that. :-)

The point about your patch breaking debouncing is still valid, though.


BR,
Jani.


