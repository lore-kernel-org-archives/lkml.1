Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXITQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXITQTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbXITQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:19:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbXITQTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:19:10 -0400
Message-ID: <46F29D7A.9070309@redhat.com>
Date: Thu, 20 Sep 2007 12:19:06 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Aggelos Manousarides <amanous@inaccessnetworks.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bogus high interrupt load?
References: <20070918235648.GA29746@inaccessnetworks.com>
In-Reply-To: <20070918235648.GA29746@inaccessnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2007 07:56 PM, Aggelos Manousarides wrote:
> 
> There is obviously something happening to the load reporting facility of
> the kernel when a periodic interrupt source is present. Has anyone seen
> something like this? I am not using any real time patches, this is a
> vanilla kernel patched only to support the platform at hand.
> 

You will get aliasing effects like that if the system clock is not
interrupting at least twice as often as your periodic interrupts occur.

