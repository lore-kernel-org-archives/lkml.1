Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbZJ0N6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbZJ0N6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZJ0N6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:58:22 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45033 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZJ0N6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 09:58:25 -0400
Message-ID: <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
Subject: Re: [PATCH] ima: remove ACPI dependency
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 9:26 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Remove ACPI dependency on systems without a TPM enabled.

I'm confused why you need ACPI at all.  The TPM code doesn't require
ACPI (I wish it did but Alan Cox Nak'd that patch).  I don't see acpi
anywhere in the ima code.  What's the problem we are solving?  Why
does IMA care about ACPI at all?  And aren't you really just dropping
the build requirement on TCG_TPM?  Is that a great idea?

-Eric
