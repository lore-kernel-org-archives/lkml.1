Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbZC3SpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbZC3SpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbZC3Sox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:44:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbZC3Sow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:44:52 -0400
Message-ID: <49D11287.4030307@redhat.com>
Date: Mon, 30 Mar 2009 14:42:15 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<1238195024.8286.562.camel@nimitz>  <20090329161253.3faffdeb@skybase> <1238428495.8286.638.camel@nimitz> <49D11184.3060002@goop.org>
In-Reply-To: <49D11184.3060002@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> That said, people have been looking at tracking block IO to work out 
> when it might be useful to try and share pages between guests under Xen.

Tracking block IO seems like a bass-ackwards way to figure
out what the contents of a memory page are.

The KVM KSM code has a simpler, yet still efficient, way of
figuring out which memory pages can be shared.

-- 
All rights reversed.
