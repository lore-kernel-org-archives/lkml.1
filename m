Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbXEaAuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbXEaAuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbXEaAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:49:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60759 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758818AbXEaAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:49:57 -0400
Date: Wed, 30 May 2007 17:49:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: young dave <hidave.darkstar@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
In-Reply-To: <a8e1da0705301735r5619f79axcb3ea6c7dd344efc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705301747370.4809@schroedinger.engr.sgi.com>
References: <20070531002047.702473071@sgi.com>  <20070531003012.302019683@sgi.com>
 <a8e1da0705301735r5619f79axcb3ea6c7dd344efc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, young dave wrote:

> Hi Christoph,
> 
> > Introduce CONFIG_STABLE to control checks only useful for development.
> 
> What about control checks only as SLUB_DEBUG is set?

Debug code is always included in all builds unless it is an embedded 
system. Debug code is kept out of the hot path.

Disabling SLUB_DEBUG should only be done for embedded systems. That is why 
the option is in CONFIG_EMBEDDED.

