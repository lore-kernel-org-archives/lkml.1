Return-Path: <linux-kernel-owner+w=401wt.eu-S1764188AbYBNT2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764188AbYBNT2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbYBNT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:28:01 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47745 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755944AbYBNT2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:28:00 -0500
Date: Thu, 14 Feb 2008 11:27:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
In-Reply-To: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com>
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excellent. Relative node masks are a nice feature and may allow us to even 
cut down the size of the bitmasks for configurations with large numbers of 
nodes.

Reviewed-by: Christoph Lameter <clameter@sgi.com>

ccing Mike since he may need something similar for cpu masks which are 
getting a bit too large for 4k systems on x86_64.


