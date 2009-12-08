Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbZLHPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbZLHPpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZLHPpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:45:11 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38666 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZLHPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M6LmS5dythOpkmMtBo5h9Mzc4TKacAn+AeWi1WxopkTtzClRJL5jfMzs8SLqcXl1/w
         RSajUN0o6KV5Gaf0yRFcRdbMzhqEh2mrYE6Y1v6BYR+NKyWD+oNRXH1NhiTq8ltVST9+
         /DXSUUOhB4Qent1FGLdKK+ghs8CbAFUAyCajY=
Message-ID: <4B1E7481.6020902@gmail.com>
Date: Tue, 08 Dec 2009 16:45:05 +0100
From: Jes Sorensen <jes.sorensen@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Toshiba Bluetooth enabler (rfkill)
References: <4B192D08.9080608@gmail.com> <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com> <20091208125530.GA23520@srcf.ucam.org>
In-Reply-To: <20091208125530.GA23520@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/09 13:55, Matthew Garrett wrote:
> The problem with that is that there's no event to indicate that the
> switch has been turned back on, so there's no way to update the rfkill
> core appropriately. Giving userspace potentially stale information
> doesn't seem helpful.

I believe I can call into BTST and determine whether the switch is set
to on or not. It's quite easy to add this to the resume handler and only
call if it's set to on.

Cheers,
Jes
