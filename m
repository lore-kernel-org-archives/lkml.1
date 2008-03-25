Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbYCYJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbYCYJ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCYJ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:57:36 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:33727 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbYCYJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:57:35 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       "Van De Ven, Arjan" <arjan@linux.intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fixing the main programmer thinko with the device model
References: <1206373188.3494.36.camel@localhost.localdomain>
	<20080324175844.GA13816@kroah.com>
	<1206382109.3494.69.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 10:57:32 +0100
In-Reply-To: <1206382109.3494.69.camel@localhost.localdomain>
Message-ID: <87ve3bi0s3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 09:50:55.0127 (UTC) FILETIME=[B810CA70:01C88E5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> That's true, but irrelevant (and also soon to be untrue if we get rid of
> the scsi_device class as you and Kay keep requesting).  The two calls
> release references on the actual embedded generic device, it's nothing
> to do with entangled lifetime rules.

<heretic thought>Has anybody ever considered just doing away with 
the problematic and bug prone and tricky reference counts for kobjects 
and switch to a simple garbage collector for them?

-Andi
