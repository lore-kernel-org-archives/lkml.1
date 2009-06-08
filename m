Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZFHQdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZFHQdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZFHQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:30758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbZFHQda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,325,1241420400"; 
   d="scan'208";a="464474198"
From: "Luck, Tony" <tony.luck@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Mon, 8 Jun 2009 09:33:31 -0700
Subject: RE: [PATCH 2/6] headers_check fix: ia64, fpswa.h
Thread-Topic: [PATCH 2/6] headers_check fix: ia64, fpswa.h
Thread-Index: AcnlUdYHMreUlKlsQo2id9zlWYMMKQDBNphA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3A89196D0@orsmsx505.amr.corp.intel.com>
References: <1244118232.5172.26.camel@ht.satnam>
 <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam>
 <20090604202212.GD13892@uranus.ravnborg.org>
In-Reply-To: <20090604202212.GD13892@uranus.ravnborg.org>
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

> Tony - is this file really used from userspace.
> Looking at the definitions I think not.
>
> I not then the real fix is to unexport it.

Sam,

FPSWA should be completely invisible to user space.  You are correct that the
right fix is to unexport it.

-Tony
