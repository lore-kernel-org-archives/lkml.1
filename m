Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZALHOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZALHOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 02:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZALHOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 02:14:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36409 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZALHOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:14:37 -0500
Message-ID: <496AEDE9.9000403@redhat.com>
Date: Mon, 12 Jan 2009 09:14:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Does CONFIG_PARAVIRT imply usage of byte locks?
References: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz> <49693515.5000106@goop.org> <alpine.LNX.1.10.0901112350580.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901112350580.5377@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Avi, are there any plans to make KVM use byte locks implementation for 
> spinlocks in the near future?
>   

No, although I note anything coming out of the spinning mutex discussion 
could be applied towards a sleeping spinlock for paravirt.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

