Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYE2Oig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYE2Oig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYE2Oi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:38:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:57687 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYE2OiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RyzLT5fXZn3Udwpq0QrPWqMRYzCTOZmzf3HD6dk8s4qKfnfe04aVY1G2wV0KDGvF8JAobfDDXBbeMbK8sTYgTvg0YXOW3UoV+PpLYEZUTDgVvUBspiqQl7ILbIy90hTf//XXkddxUH8XAVxWW0Kxl+grzQZ6S1gHgKObPl3EsaA=
Message-ID: <483EBFC5.7020406@gmail.com>
Date: Thu, 29 May 2008 23:37:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com> <20080529140213.GA23373@srcf.ucam.org> <20080529141421.GC9268@homac.suse.de> <20080529143541.GA24013@srcf.ucam.org>
In-Reply-To: <20080529143541.GA24013@srcf.ucam.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Thu, May 29, 2008 at 04:14:21PM +0200, Holger Macht wrote:
>> On Thu 29. May - 15:02:13, Matthew Garrett wrote:
>>> No, I'm seeing an identical hang. Mainline works fine.
>> Maybe you could also try this on top of Tejun's patch?
> 
> No luck there either, I'm afraid.

That means device isn't being detached or something afterwards triggers
hotplug event on the detached port.  Can you please sprinkle printks
around and see what ata_acpi_handle_hotplug() does?

Thanks.

-- 
tejun
