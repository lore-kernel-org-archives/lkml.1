Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbYJKTi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbYJKTi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 15:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYJKTiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 15:38:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:48793 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbYJKTiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 15:38:50 -0400
Message-ID: <48F100CA.2050600@suse.de>
Date: Sat, 11 Oct 2008 23:38:50 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810112130.57757.rjw@sisk.pl> <48F0FEFA.7050308@gmail.com> <200810112140.16662.rjw@sisk.pl>
In-Reply-To: <200810112140.16662.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> No, we discussed this before -- we are outside of the transaction, thus 
>> no GPE
>> activity could interfere with ec_check_ibf0.
> 
> Ok, this is in the process context and we don't really expect to get an
> interrupt at this point, but what happens if the EC generates an event that's
> not related to any transiaction.  Is that guaranteed to never happen?
Interrupt handler in this case can't cause a change to status register, thus our 
read of it will not be affected by interrupt.
> 
> Thanks,
> Rafael

