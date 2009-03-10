Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZCJNoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZCJNoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZCJNnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:43:52 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:13296 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZCJNnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:43:51 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Mar 2009 13:42:49 +0000
Subject: RE: [PATCH] tweak spin logic for hpilo
Thread-Topic: [PATCH] tweak spin logic for hpilo
Thread-Index: AcmhC26BGbDDgIaeS+emO6GG3qjIPgAeYI2w
Message-ID: <92D64232F2316045B18937D5C9996B1522834ABED6@GVW1144EXB.americas.hpqcorp.net>
References: <20090309225651.GA13702@ldl.fc.hp.com>
 <20090309160437.b71041d5.akpm@linux-foundation.org>
In-Reply-To: <20090309160437.b71041d5.akpm@linux-foundation.org>
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

> From: Andrew Morton
> David Altobelli wrote:
> > Change hpilo open and close logic to spin for 10usec between checking
> > device, rather than every usec.
> 
> err.. Why?

Because the loop is coded to take up to 10ms, it seemed prudent to increase
the interval between polling the device, to reduce the load on the system and
allow more other work to happen.
