Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbYEWFCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbYEWFCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYEWFCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:02:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20323 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760557AbYEWFC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q+a2o9mfSzx3/bw7SCBx6upt26dnpQKE/ydpmuC63b6p3+ShVeYogAUc3bDBkj1/gUB2/NAr3RhVm00hrdTxnRYhwn3hmihVALzD5sXUBOt2J4cheoEJ369mskp5FLu0MMtRFrvmFhSnne5ABTa5KxDXDUwKSz6zv7y1ln+NKgA=
Message-ID: <a36005b50805222202v6ea7b50p988eab5524935e1a@mail.gmail.com>
Date: Thu, 22 May 2008 22:02:19 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080523042923.916202203@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 12:00 AM, Daniel Walker <dwalker@mvista.com> wrote:
> This patch corrects this issue, so the tasks are always woken in priority
> order.

This is completely unnecessary overhead for 99.999% of all cases.  It
was deliberately not done.  You slowing things down for everybody.  If
you want priorities, then use PI futexes.
