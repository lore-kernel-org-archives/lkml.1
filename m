Return-Path: <linux-kernel-owner+w=401wt.eu-S935254AbXEWRSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254AbXEWRSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbXEWRSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:18:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53703 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756240AbXEWRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:18:31 -0400
Date: Wed, 23 May 2007 10:18:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <46540DB2.5000605@googlemail.com>
Message-ID: <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Michal Piotrowski wrote:

> Christoph, this looks like a bug in SLUB.

Please boot with slub_debug to find the bad code that overwrites a slab 
object after it was freed.

