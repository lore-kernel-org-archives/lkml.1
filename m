Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0BMWxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:53:23 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:43106 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab0BMWxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:53:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gwBtSOCbJUldCqgxhaDe/gNK5/f+9y7/ypCmuOt45IabXQTJyeESuATqgRZVtyFsKa
         wqE07XRo7OoC33sjHSPoaKzlpSNtgZuOIzBSfdKsVW9I9digzqAiq5ODqYd8LOHczZUK
         Ergzqfu7FxUaMrdOZ8aCr5QDipYERS9qBR+1o=
MIME-Version: 1.0
In-Reply-To: <4B772BE2.30108@garzik.org>
References: <4B5FC213.1060601@gmail.com> <4B772BE2.30108@garzik.org>
Date: Sat, 13 Feb 2010 16:53:20 -0600
Message-ID: <51f3faa71002131453m4dd2b82cgd8b874866146da60@mail.gmail.com>
Subject: Re: [PATCH] ahci: disable FPDMA auto-activate optimization on NVIDIA 
	AHCI
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Mike Cui <cuicui@gmail.com>,
       Peer Chen <pchen@nvidia.com>, Allen Martin <AMartin@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 4:46 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 01/26/2010 11:33 PM, Robert Hancock wrote:
>>
>> Mike Cui reported that his system with an NVIDIA MCP79 (aka MCP7A) chipset
>> stopped working with 2.6.32. The problem appears to be that 2.6.32 now
>> enables
>> the FPDMA auto-activate optimization in the ahci driver. The drive works
>> fine
>> with this enabled on an Intel AHCI so this appears to be a chipset bug.
>> Since MCP79 is a fairly recent NVIDIA chipset and we don't have any info
>> on
>> whether any other NVIDIA chipsets have this issue, disable FPDMA AA
>> optimization
>> on all NVIDIA AHCI controllers for now.
>>
>> Should address http://bugzilla.kernel.org/show_bug.cgi?id=14922
>>
>> Signed-off-by: Robert Hancock<hancockrwd@gmail.com>
>>
>> ---
>>
>> Mike, can you test this out and make sure this resolves the problem for
>> you?
>
> Sigh...   we never did hear back from Mike or NVIDIA on this one, did we?
>  I've been watching for a response, and haven't seen one to date.

No, I haven't seen a response. It's pretty apparent it should fix the
problem based on earlier testing, but it would be nice to find out for
sure which chipsets this affects.
