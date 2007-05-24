Return-Path: <linux-kernel-owner+w=401wt.eu-S1751232AbXEXSQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbXEXSQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXEXSQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:16:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52692
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXEXSQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:16:34 -0400
From: Rob Landley <rob@landley.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Status of CONFIG_FORCED_INLINING?
Date: Thu, 24 May 2007 14:14:19 -0400
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
References: <200705231510.52932.rob@landley.net> <200705241347.43727.rob@landley.net> <4655CFB8.7060708@linux.intel.com>
In-Reply-To: <4655CFB8.7060708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241414.20258.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 1:47 pm, Arjan van de Ven wrote:
> Rob Landley wrote:
> > If the compiler can emit a warning "inline insanely large", we can use 
that to 
> > fix it.  But a warning is not the same as silently doing something other 
than 
> > what we told it to do.
> 
> It's not silent! that's what "inline" without the force is for!
> Once you force it you shut the warning up!!!!

So presumably, a debug option could #define __always_inline to just "inline" 
in order to get warning messages to look at?

Rob
