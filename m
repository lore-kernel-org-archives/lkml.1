Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbXKMTM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbXKMTM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXKMTMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:12:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbXKMTMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:12:48 -0500
Message-ID: <4739F609.50501@zytor.com>
Date: Tue, 13 Nov 2007 11:07:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca>
In-Reply-To: <20071113190040.740103668@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
- Use "=g" constraint for char immediate value inline assembly.

"=g" is the same as "=rmi" which is inherently bogus.  In your actual 
code you use "=r", the correct constraint is "=q".

	-hpa
