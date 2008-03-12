Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbYCLOiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbYCLOiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYCLOiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYCLOiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:38:05 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: debug AT, AR, and selfID-complete events
Date: Wed, 12 Mar 2008 10:34:39 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.f96c4067f6a48f4a@s5r6.in-berlin.de> <tkrat.ebca3f78fa768606@s5r6.in-berlin.de> <47D79F3E.60803@s5r6.in-berlin.de>
In-Reply-To: <47D79F3E.60803@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121034.39583.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 05:15:42 am Stefan Richter wrote:
> I wrote:
> > +MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
> > +	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
> > +	", AT and AR events = "	__stringify(OHCI_PARAM_DEBUG_AT_AR)
> > +	", or a combination)");
>
> Interrupt event logging needs to be added as well.

Want to do that as a later follow-up patch, or roll it into this one and post 
another update? (I'm fully prepared to sign off on either way after having 
extensively used these patches the past several days...)

-- 
Jarod Wilson
jwilson@redhat.com
