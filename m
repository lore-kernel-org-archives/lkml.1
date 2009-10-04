Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZJDRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZJDRDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 13:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZJDRDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 13:03:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:61547 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZJDRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 13:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lm8BGjfUe3JYYHSb8ezH9xTURkXPfJxq3SJ1PhpILKTmJeiSEGjsTybNrnM5XAskLL
         1fnh6FDPWkuicpZjqXZO9JShq0hZZJU7cRUCzaPmjD9ng5uOzljc6Ctmb7dIqG3CkYW7
         qGnMYj4agBEB5QlRvGsuigDgjIi8pIRnj9v9A=
Message-ID: <4AC8D568.9090103@tuffmail.co.uk>
Date: Sun, 04 Oct 2009 18:03:36 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: pm list <linux-pm@lists.linux-foundation.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc1: various BUGs on resume from hibernation
References: <4AC8B4A8.3050601@tuffmail.co.uk>
In-Reply-To: <4AC8B4A8.3050601@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
> Sometimes they cause a hang during resume; sometimes they happen just 
> after resume.  It doesn't happen all the time either -  I've just 
> hibernated three times in a row with no problems.  It's most perplexing.
>
> One resume hang showed a series of SCSI backtraces and errors.  
> Unfortunately I wasn't able to capture it at the time.  They were most 
> probably related to the root device, an SSD controlled by ata_piix.
>
> Today on latest -git I captured this "bad swap file entry" problem.  I 
> use a swap file for hibernation (I don't have a swap partition).

> Previously, on a slightly older kernel (still after 32-rc1), I 
> captured this BUG in fget_light():

And later suspend to ram failed, and then showed a hung task warning.

I've attached everything at 
<http://bugzilla.kernel.org/show_bug.cgi?id=14320>.

Thanks
Alan


