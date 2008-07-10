Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbYGJNvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbYGJNvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYGJNvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:51:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbYGJNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:51:19 -0400
Message-ID: <48761378.6050101@zytor.com>
Date: Thu, 10 Jul 2008 09:49:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed using
 'upx'
References: <200807100655.00857.elendil@planet.nl>
In-Reply-To: <200807100655.00857.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> 
> So, the primairy question here is:
> - is this a kernel regression because whatever changed is no longer valid
>   conform "kernel format specs", or
> - is this a latent issue in upx that somehow creates an invalid image, or
> - does this change effectively create a new "type" of image that upx
>   just doesn't yet know how to handle correctly?
> 

Sounds to me like UPX makes assumptions about the kernel image format 
that it really doesn't have standing to assume.

	-hpa
