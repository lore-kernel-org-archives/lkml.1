Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZE2Nnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZE2Nnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbZE2Nm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:38722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760328AbZE2Nmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="519893860"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:42:06 +0100
Subject: RE: [PATCH v2 07/11] async_tx: kill needless module_{init|exit}
Thread-Topic: [PATCH v2 07/11] async_tx: kill needless module_{init|exit}
Thread-Index: AcndItICFzZz0C+ISJu4x4A8ySnByQDNyyNA
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C71@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010001.4104.24270.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250323o21113fb9xbc4c16eea07b215@mail.gmail.com>
In-Reply-To: <f12847240905250323o21113fb9xbc4c16eea07b215@mail.gmail.com>
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
> If module_init and module_exit are nops then neither need to be defined.
> 
> [ Impact: pure cleanup ]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_memcpy.c |   13 -------------
>  crypto/async_tx/async_memset.c |   13 -------------
>  crypto/async_tx/async_tx.c     |   17 +++--------------
>  3 files changed, 3 insertions(+), 40 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>