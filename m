Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbXHPPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbXHPPXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbXHPPXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:23:35 -0400
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:52983 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXHPPXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:23:34 -0400
X-Greylist: delayed 1307 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 11:23:34 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 1/1] cciss: fix error reporting for SG_IO
Date: Thu, 16 Aug 2007 14:53:55 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B401168058@G3W0634.americas.hpqcorp.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] cciss: fix error reporting for SG_IO
thread-index: AcferOd7rh7J7abQSL2vUcOAw5HbsgBaF0zn
References: <20070814195338.GA10828@beardog.cca.cpqcorp.net>
From: "Cameron, Steve" <Steve.Cameron@hp.com>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <jens.axboe@oracle.com>, <james.bottomley@steeleye.com>,
       <hch@infradead.org>
X-OriginalArrivalTime: 16 Aug 2007 14:58:51.0808 (UTC) FILETIME=[F5521200:01C7E015]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Any feedback on my patch?

Anybody know what the msg_byte in include/scsi/scsi.h
is for?

scsi.h says:
 *      msg_byte    = return status from host adapter itself.

So, it's ok to use the msg_byte for device specific error codes?

-- steve
