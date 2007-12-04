Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXLDU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXLDU22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXLDU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:28:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55573 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXLDU2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:28:20 -0500
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071204200558.GB1988@Krystal>
References: <20071129023421.GA711@Krystal>
	 <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal>
	 <1196444801.18851.127.camel@localhost> <20071130170516.GA31586@Krystal>
	 <1196448122.19681.16.camel@localhost> <20071130191006.GB3955@Krystal>
	 <y0mve7ez2y3.fsf@ton.toronto.redhat.com> <20071204192537.GC31752@Krystal>
	 <1196797259.6073.17.camel@localhost>  <20071204200558.GB1988@Krystal>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:28:16 -0800
Message-Id: <1196800096.6073.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or, think out of the box...

Maybe you can introduce some interfaces that expose information both in
sysfs (in normal human-readable formats) and in a way that lets you get
the same data out in some binary format.  

Seems to me you'll have a lot easier time justifying all of these lines
of code spread all over the kernel if there are a few more users off the
bat.  

-- Dave

