Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbYCXTbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbYCXTbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYCXTbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:31:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53206 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757583AbYCXTbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:31:34 -0400
Date: Mon, 24 Mar 2008 12:29:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [00/14] Virtual Compound Page Support V3
In-Reply-To: <Pine.LNX.4.64.0803241129100.3002@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0803241228410.3959@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080322114043.17833ab4@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0803241129100.3002@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the other hand: The conversion of vmalloc to vcompound_alloc will 
reduce the amount of virtually mapped space needed. Doing that to 
alloc_large_system_hash() etc may help there.


