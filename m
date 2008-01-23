Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbYAWJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbYAWJcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 04:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYAWJcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 04:32:07 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:11312
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbYAWJcG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 04:32:06 -0500
Message-Id: <479717C8.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 23 Jan 2008 09:32:40 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Greg KH" <greg@kroah.com>
Cc: <davem@davemloft.net>, <schwidefsky@de.ibm.com>, <mingo@elte.hu>,
       <tony.luck@intel.com>, <paulus@samba.org>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] constify struct attribute_group uses (against
	-mm)
References: <4795FE39.76E4.0078.0@novell.com>
 <20080122221547.GA32588@kroah.com>
In-Reply-To: <20080122221547.GA32588@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Greg KH <greg@kroah.com> 22.01.08 23:15 >>>
>On Tue, Jan 22, 2008 at 01:31:21PM +0000, Jan Beulich wrote:
>> .. as all consumers of it don't require it to be modifiable.
>> 
>> Unfortunately, due to the two-level constifications, this required
>> touching quite many files, not all of which I am able to test - please
>> bare with eventual mistakes or oversights.
>> 
>> The patch doesn't change all instances where 'const' could have been
>> added as a result of the base structure changes, only where either the
>> change has a real effect (the module loader doesn't enforce read-only
>> section attributes at present, so only built-in files matter) or where
>> compiler warnings would result otherwise.
>
>Which -mm is this against?  Seems to not apply here :(

2.6.24-rc8-mm1 - I'm keeping the name in the diff headers so that one
can easily identify the baseline a patch is against, as in

--- 2.6.24-rc8-mm1-const.orig/arch/ia64/kernel/err_inject.c
+++ 2.6.24-rc8-mm1-const/arch/ia64/kernel/err_inject.c

Jan

