Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXDIQzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXDIQzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXDIQzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:55:09 -0400
Received: from holomorphy.com ([66.93.40.71]:49765 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbXDIQzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:55:08 -0400
Date: Mon, 9 Apr 2007 09:44:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 6/7] Containers (V8): BeanCounters over generic process containers
Message-ID: <20070409164434.GU2986@holomorphy.com>
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.840593000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.840593000@menage.corp.google.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 04:32:27PM -0700, menage@google.com wrote:
> This patch implements the BeanCounter resource control abstraction
> over generic process containers. It contains the beancounter core
> code, plus the numfiles resource counter. It doesn't currently contain
> any of the memory tracking code or the code for switching beancounter
> context in interrupts.
> Currently all the beancounters resource counters are lumped into a
> single hierarchy; ideally it would be possible for each resource
> counter to be a separate container subsystem, allowing them to be

I'm very happy to see the BeanCounter work revived. The utility of
this work should extend far beyond feature work like containers and
into stability and reliability areas as well.


-- wli
