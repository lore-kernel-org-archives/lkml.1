Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbYECJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbYECJlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758950AbYECJln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 05:41:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:2835 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbYECJlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 05:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QjzdEdcCDtiiE+MubqkZ6LSJ9XCjBDHhTsvJ+LjIXIDEup0SV7f6Mad0Dhm9IGg/l8bZB/QNMtE9Sg/q8uG8+aH0vYOMXRajuSzqo3R37PE1aTf4cjadqz0WMecNL0MiiFdV0WLAHSsjsYS+7Rws473PJgTs7DOPc9UxAZDpwgw=
Message-ID: <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
Date: Sat, 3 May 2008 11:41:41 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Subject: Re: SCSI target subsystem
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
In-Reply-To: <481B5AB8.5030108@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com>
	 <1209745084.3121.39.camel@localhost.localdomain>
	 <481B5AB8.5030108@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 8:17 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> I wrote all above to support my at first glance shocking conclusion that
> SCSI target subsystem is completely new subsystem of the kernel and it
> should live on its own with its own maintainer! This is the same as with the
> current interaction between SCSI and block subsystems in the kernel: SCSI
> uses block's functionality, but that doesn't mean that block and SCSI are
> the same subsystem.

Hello Tomo,

Due to the IET and STGT projects you have a lot of experience with
implementing SCSI target frameworks. What is your opinion about how a
kernel space SCSI target framework should fit in the Linux kernel ?

Bart.
