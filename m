Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZIOQKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZIOQKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZIOQKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:46562 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbZIOQKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:10:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,391,1249282800"; 
   d="scan'208";a="550784426"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:10:46 +0100
Subject: RE: [PATCH 16/18] ioat3: segregate raid engines
Thread-Topic: [PATCH 16/18] ioat3: segregate raid engines
Thread-Index: AcotK1v7dpVDiDtrQyq0qKcGUO4XewI87Kgw
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554879D@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064556.7141.76580.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064556.7141.76580.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> The cleanup routine for the raid cases imposes extra checks for handling
> raid descriptors and extended descriptors.  If the channel does not
> support raid it can avoid this extra overhead by using the ioat2 cleanup
> path.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>