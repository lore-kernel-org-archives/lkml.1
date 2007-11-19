Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbXKSEiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbXKSEiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 23:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXKSEiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 23:38:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:3429 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXKSEiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 23:38:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Pl0R625milO+CpJ7kPimkC00O07rcuaArwdOaYarzkk+Rtf+2BkKgS6Oo7OyHzqrTOT/C0gQCpv9R3lLPVUivNhvyCvo9aAIcq3YL1JEJ/994eSRecXah3ntzea0DS0OL50SvBTZSm0kd7OkZHvFc7LR0/pmBlnnOqI0bUs9O1A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Raymano Garibaldi" <raymano@faunos.com>
Subject: Re: [BUG] USB_PERSIST
Date: Sun, 18 Nov 2007 20:37:57 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <1618816c0711182014n293b9429y53bfcf219a624260@mail.gmail.com>
In-Reply-To: <1618816c0711182014n293b9429y53bfcf219a624260@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182037.57725.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 November 2007 20:14, Raymano Garibaldi wrote:
> In kernel 2.6.23.8 USB_PERSIST feature does not work if the same USB
> device is detached and reattached while computer is suspended. The
> mount points for the USB storage device mounted before suspend are
> lost and the device has to be remounted after resume.

Does it work in 2.6.23.7? What messages you see in the kernel logs
(in both kernels, good and bad)?
--
vda
