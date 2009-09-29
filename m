Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZI2Lkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZI2Lkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 07:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZI2Lki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 07:40:38 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:32955 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZI2Lki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 07:40:38 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 13:40:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <20090929103354.GA3766@amit-x200.redhat.com> <200909291302.51432.borntraeger@de.ibm.com>
In-Reply-To: <200909291302.51432.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291340.37431.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 13:02:51 schrieb Christian Borntraeger:
> I took a dump and had a look. It looks that this message thing is indeed
>  not the problem. Our early_put_chars method was marked as __init and the
>  old code replaced the put_chars method quickly enough to never make a
>  problem. Removing the __init from early_put_chars solved this kernel bug,
>  but the tty performance is now horribly slow. I will test, if the
>  put_chars method is replaced at all.

I can confirm that your patch changes virtio_console in a way, that the 
early_put_chars function is not replaced by the final one, but I dont see why.

Christian
