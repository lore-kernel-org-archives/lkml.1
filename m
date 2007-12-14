Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXLNWj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXLNWj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934278AbXLNWf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:35:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934269AbXLNWfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:35:25 -0500
Message-ID: <47630521.4060505@redhat.com>
Date: Fri, 14 Dec 2007 17:35:13 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org>
In-Reply-To: <20071214101720.GA10981@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2007 05:17 AM, Andi Kleen wrote:
>> so do whatever is necessary to enable dynticks. 
> 
> dynticks' main purpose is to save power, but C1e saves more power.
> Disabling C1e for dynticks would be a fairly useless default
> trade off.
> 

What about machines where the BIOS has disabled C1e on CPU 0 but
left it enabled on CPU 1 ??
