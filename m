Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZHTQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZHTQKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZHTQKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:10:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58949 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZHTQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:10:39 -0400
Date: Thu, 20 Aug 2009 18:10:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Wang, Shane" <shane.wang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Cihula, Joseph" <joseph.cihula@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [RFC v6][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt
	shutdown support
Message-ID: <20090820161038.GA29994@basil.fritz.box>
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 05:33:50PM +0800, Wang, Shane wrote:
> Hi Ingo & hpa,
> 
> I have made some change on the previous tboot patch to fix the build errors.
> Please comment.

The standard way to do this would be to define a linux/tboot.h
that does the ifdef and in the else path define dummy inlines
for these functions.

-Andi
