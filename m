Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbZKZQWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbZKZQWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbZKZQWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:22:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760677AbZKZQWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:22:35 -0500
Subject: Re: Missing recalculation of scheduler tunables in case of cpu hot
 add/remove
From: Peter Zijlstra <peterz@infradead.org>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Holger.Wolf@de.ibm.com, epasch@de.ibm.com
In-Reply-To: <4B0EA88E.3030205@linux.vnet.ibm.com>
References: <4B0EA88E.3030205@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 17:22:25 +0100
Message-ID: <1259252545.31676.210.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 17:10 +0100, Christian Ehrhardt wrote:
> We might store the corresponding 1cpu values in hidden variables and 
> rescale the effective ones on every cpu add/remove.
> Additionally there would be the need for some logic to update the 
> corresponding 1cpu values every time a user sets new values via the proc 
> interface. 

If you're going to do something like that, setting it based on the
number of cpus in the root_domain might be a better solution.

