Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZJ0P7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZJ0P7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZJ0P7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:59:47 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:52721 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbZJ0P7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:59:46 -0400
Subject: Re: [PATCH] ima: remove ACPI dependency
From: David Safford <safford@watson.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       Mimi Zohar <zohar@us.ibm.com>, Stable Kernel <stable@kernel.org>
In-Reply-To: <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <7e0fb38c0910270658v153480fdt5ced717feca76c17@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Oct 2009 11:59:06 -0400
Message-Id: <1256659146.3028.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 09:58 -0400, Eric Paris wrote:
> On Mon, Oct 26, 2009 at 9:26 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Remove ACPI dependency on systems without a TPM enabled.
> 
> I'm confused why you need ACPI at all.  The TPM code doesn't require
> ACPI (I wish it did but Alan Cox Nak'd that patch).  I don't see acpi
> anywhere in the ima code.  What's the problem we are solving?  Why
> does IMA care about ACPI at all?  And aren't you really just dropping
> the build requirement on TCG_TPM?  Is that a great idea?
> 
> -Eric

This is discussed in the LSM thread:
http://marc.info/?l=linux-security-module&m=125322062401677&w=2

Basically, if running on a system with a TPM, IMA wants the TPM
boot measurement log, which the TPM driver can only get through
ACPI. If the platform does not have a TPM, then IMA does not 
need ACPI. 

dave
