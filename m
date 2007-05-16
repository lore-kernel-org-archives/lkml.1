Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbXEPIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbXEPIb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXEPIbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:31:50 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:14912 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756634AbXEPIbu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:31:50 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=uJEMU1iTlxATwz3+Tm/jCwZItphcgl8iZn02/Gjv0i+NTscJXNdGzX/76Yqw9Eaf2j4FcNYjx/yFEvAo6JLzLMrZb4ITyOisqqiPHNw03lJ9ZmBwjzxNspZhsQ5rUIN8;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.14,541,1170630000"; 
   d="scan'208";a="68895616"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: How to guarantee that kmalloc returns an address below 4GB
Date: Wed, 16 May 2007 10:30:29 +0200
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF054F922A@ABGEX01E.abg.fsc.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to guarantee that kmalloc returns an address below 4GB
Thread-Index: AceXlHYH+2wZSrZfTOGaX9KELWM7EA==
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 May 2007 08:31:33.0097 (UTC) FILETIME=[9BF72D90:01C79794]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

is there an option for kmalloc, which I can use to allocate a buffer which is in physical memory placed below 4GB?
Not in a remapped area.
The only way I found is to use GFP_DMA, but this says the first 16MB isn't it?

Ciao Thilo
