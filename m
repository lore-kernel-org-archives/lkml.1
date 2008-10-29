Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYJ2X2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYJ2X2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYJ2X2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:28:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:8768 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJ2X2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=eJjI3aqU3qWOc5TQowkfpqqOYFmmZzzAKc912YIeh2vUdoH8PL/kmiVv4t8rbAomrY
         vpJcC6BV4VJrVRZEmYOqFpUtBK8H8oXZQ5dCkUDpS7FSQYNV9gSjlSmYtYqXmUapAWPy
         +2bsOFhS+ouR5LVpxQxz13TP+XnvrQ8kZJjos=
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
References: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
	<200810300027.19116.rjw@sisk.pl>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Thu, 30 Oct 2008 00:28:27 +0100
In-Reply-To: <200810300027.19116.rjw@sisk.pl> (Rafael J. Wysocki's message of "Thu\, 30 Oct 2008 00\:27\:18 +0100")
Message-ID: <87abcnj810.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:

 Rafael> On Wednesday, 29 of October 2008, Peter Korsgaard wrote:
 >> Hi,
 >> 
 >> I'm seing what looks like a kobject reference count issue with
 >> mtdblock_ro + mtd_dataflash + mtd partitions and repeated unbind/bind.
 >> I'm on 2.6.28-rc2, but I can reproduce the problem on 2.6.27 as well.

 Rafael> Is it reproducible with 2.6.26 too?

Sorry, I haven't backported my platform support code to such "old"
kernel. I can do it though, if you think it will help pinpoint the
issue.

-- 
Bye, Peter Korsgaard
