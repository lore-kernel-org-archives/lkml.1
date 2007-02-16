Return-Path: <linux-kernel-owner+w=401wt.eu-S1946058AbXBPTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946058AbXBPTd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946068AbXBPTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:33:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946058AbXBPTdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:33:53 -0500
Message-ID: <45D606A0.5020606@redhat.com>
Date: Fri, 16 Feb 2007 14:31:44 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com> <p73odntg9ga.fsf@bingen.suse.de>
In-Reply-To: <p73odntg9ga.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Chuck Ebbert <cebbert@redhat.com> writes:
>> So, could ACPI and the k8temp driver be at odds?
> 
> Yes, there is no locking between ACPI and Linux drivers for register access.
> e.g. if there is a indexed register both try to access (and temperature
> sensors tend to use these things) they can race and get corrupted data.

I blacklisted the k8temp driver and everything looks OK now.

