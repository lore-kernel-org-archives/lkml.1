Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZEFJi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZEFJi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZEFJiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:38:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51757 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754390AbZEFJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:38:08 -0400
Date: Wed, 6 May 2009 10:38:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Norman Diamond" <n0diamond@yahoo.co.jp>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: sg timeout problem
Message-ID: <20090506103852.19cb69b9@lxorguk.ukuu.org.uk>
In-Reply-To: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600>
References: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But if sg is running on top of an actual SCSI driver, someone aborts the
> ioctl after 3 seconds.  The ioctl returns success even though the operation
> didn't complete.  I tried this with two Adaptec drivers and one NinjaSCSI 
> driver with 100% repro.
> 
> What am I missing?  I need the call to run to completion. 

If you set it to the max of a signed int does it behave, or to a large
value thats well under the limit. That will help tell if there is a
problem with sign handling in the scsi code somewhere or it is getting
multiplied up for some reason.
