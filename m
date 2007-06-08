Return-Path: <linux-kernel-owner+w=401wt.eu-S1030571AbXFHTIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030571AbXFHTIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXFHTIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:08:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43922 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017AbXFHTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:08:31 -0400
Date: Fri, 8 Jun 2007 12:08:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 00/12] Slab defragmentation V3
In-Reply-To: <6bffcb0e0706081156u4ad0cc9dkf6d55ebcbd79def2@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706081207400.2082@schroedinger.engr.sgi.com>
References: <20070607215529.147027769@sgi.com>  <466999A2.8020608@googlemail.com>
  <Pine.LNX.4.64.0706081110580.1464@schroedinger.engr.sgi.com>
 <6bffcb0e0706081156u4ad0cc9dkf6d55ebcbd79def2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Michal Piotrowski wrote:

> Yes, it does. Thanks!

Ahhh... That leds to the discovery more sysfs problems. I need to make 
sure not to be holding locks while calling into sysfs. More cleanup...

