Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZI2KJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZI2KJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZI2KJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 06:09:50 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:48338 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZI2KJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 06:09:49 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 12:09:25 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <20090922154549.GA11379@amit-x200.redhat.com> <20090929092431.GA3368@amit-x200.redhat.com>
In-Reply-To: <20090929092431.GA3368@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291209.25775.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 11:24:31 schrieb Amit Shah:
> OK; how I solved this is: a new internal message between the guest and
> the host. If a host is a console port, the host has to indicate that by
> passing a message to the guest and the guest then hooks it up with hvc.

I am curious how you going to make this compatible with existing code that 
currently uses virtio console.

Christian
