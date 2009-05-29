Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbZE2NpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbZE2NpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759856AbZE2NnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:43:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:56748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760412AbZE2Nm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="416798747"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:42:25 +0100
Subject: RE: [PATCH v2 11/11] async_tx: raid6 recovery self test
Thread-Topic: [PATCH v2 11/11] async_tx: raid6 recovery self test
Thread-Index: AcndIw98X6fPm8MNT5+7XvEI/hf4XwDPIgMw
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C75@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250324k2b4a0c7as9ac9b084d3707ce5@mail.gmail.com>
In-Reply-To: <f12847240905250324k2b4a0c7as9ac9b084d3707ce5@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> Port drivers/md/raid6test/test.c to use the async raid6 recovery
> routines.  This is meant as a unit test for raid6 acceleration drivers.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/Makefile    |    1
>  crypto/async_tx/raid6test.c |  212 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/Kconfig          |   13 +++
>  3 files changed, 226 insertions(+), 0 deletions(-)
>  create mode 100644 crypto/async_tx/raid6test.c

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
