Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYELTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYELTcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYELTcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:32:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:29652 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYELTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UGT4oKuLIVVOC5vajvQoGllyrymc/0WCXhWVQmo4X9Crw6LXW9iKmNb3grIVWnfWBEcxqREbhGbsqcnTdVLM1wtXFKQ5zrNGHrDh7rQADa3AdTITFJlEDvACrPzJQWNVRfzLMiwadY67/m/kvzxQglwhJOtolvHczjuUmGPq5G0=
Message-ID: <e2e108260805121232t4cbd8eb0k219fd6a7d06c7650@mail.gmail.com>
Date: Mon, 12 May 2008 21:32:07 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc2
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 4:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> A few months ago we dropped the regular BKL version, but in 2.6.25-rc1 we
> then had performance (and then correctness) issues with the interaction
> between the semaphore implementation and the preemptable BKL, so we're
> back to the old regular version for now.

Hello Linus,

Sorry if it's my fault that I do not understand the above message
completely. But from the above it's not completely clear to me which
kernel versions (2.6.2?.? releases) are affected and which are not
affected by the performance and correctness issues due to the
interaction between the semaphore implementation and the preemptable
BKL. Can someone please be so kind to post the affected kernel
versions ? And whether or not this issue was triggered probably
depends on the CONFIG_... options with which the kernel was built ?

Bart.
