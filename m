Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0BPOAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:00:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:52003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab0BPOAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:00:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,484,1262592000"; 
   d="scan'208";a="492870526"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Denis Turischev <denis@compulab.co.il>
CC: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Date: Tue, 16 Feb 2010 05:59:34 -0800
Subject: RE: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Thread-Topic: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Thread-Index: Acqu78Pod05ZPZ29TgSLOSr7DatsGQAIAJtg
Message-ID: <43F901BD926A4E43B106BF17856F0755A2D58DB5@orsmsx508.amr.corp.intel.com>
References: <4B73DAEE.5080400@compulab.co.il>
 <4B73DB4B.40501@compulab.co.il> <20100216100809.GA2935@sortiz.org>
In-Reply-To: <20100216100809.GA2935@sortiz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>On Thu, Feb 11, 2010 at 12:26:19PM +0200, Denis Turischev wrote:
>> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
>> functions. Creating and MFD driver for the LPC bridge controller allows
>> simultaneous use of SMBus and GPIO interfaces on the SCH.
>That looks like an nice patch to me. Before merging it, I'd like to get
>Jacob's view on it though. Jacob, does moving the SCH SMBus driver to a
>platform one look fine to you ?
>
[[JPAN]] i agree with merging gpio and smbus into lpc driver. the only question
i had was whether impact to the user space tools has been considered. iirc,
there are sensors detect tools probe pci bus for smbus controllers, not sure it
does that for platform bus.

