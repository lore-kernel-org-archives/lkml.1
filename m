Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXEWTLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXEWTLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbXEWTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:11:00 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54517
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXEWTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:11:00 -0400
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: Status of CONFIG_FORCED_INLINING?
Date: Wed, 23 May 2007 15:10:52 -0400
User-Agent: KMail/1.9.1
Cc: Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231510.52932.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that feature-removal-schedule.txt has CONFIG_FORCED_INLINING 
scheduled to go away most of a year ago.  My question is what replaces it:

Does #define inline __always_inline become the new standard and uses of 
__always_inline be removed, or should all instances of "inline" either be 
removed or replaced with __always_inline?  (Or are there going to be two 
keywords meaning exactly the same thing going forward?)

Rob
