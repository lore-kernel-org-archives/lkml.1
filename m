Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZCJOqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZCJOqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZCJOqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:46:37 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56264 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbZCJOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:46:36 -0400
Subject: Re: [PATCH] unnecessary SCSI module
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Brueckl <ib@wupperonline.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <49b60f4c@wupperonline.de>
References: <49b60f4c@wupperonline.de>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 09:46:30 -0500
Message-Id: <1236696391.3316.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 08:00 +0100, Ingo Brueckl wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> >> When configuring MODULES with the kernel to be able to load external
> >> drivers coming as modules, but not using anything as module in the kernel
> >> itself, one would expect to end up in a module-free kernel. Currently, you
> >> don't if you use SCSI. You'll get one unnecessary module.
> 
>  > This isn't right because SCSI_SCAN_ASYNC only sets the *default*
>  > behaviour of the kernel.  Even if it's n the user can still boot up with
>  > async scans by setting the kernel parameter.
> 
> Ok, understood. But has it to be a module then? Why not giving the choice
> between building it directly into the kernel or as a module?

If you read through the threads, that question is answered.

>  > It also keeps coming up regularly:
> 
> Well, then something doesn't seem to be ok, does it? ;-)

James


