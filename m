Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYJVNX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYJVNX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYJVNXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:23:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:39058 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYJVNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i+jtMYI9H/zLJyIlNKVY01V8EhGUYAa2BNFnfKo4r+2AXmoIQ/bY1rtu/gVInq+zef
         riQPyZPO8eCet4WfS0xheE83Y6wbwrjkL6QNvNP8A/CzH4VR36k9U6ho+0TJWf0fHxO4
         QSVlw/0fFGS2uJAEOGnTMd6Rgzf8bov4hy3Uk=
Message-ID: <94a0d4530810220623w150af153n68889bfd199be8ce@mail.gmail.com>
Date: Wed, 22 Oct 2008 16:23:47 +0300
From: "Felipe Contreras" <felipe.contreras@gmail.com>
To: "Tony Vroon" <tony@vroon.org>
Subject: Re: Issue with e1000
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1224679411.4001.25.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <94a0d4530810220448x41241926r8f93cde4463b9864@mail.gmail.com>
	 <1224679411.4001.25.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 3:43 PM, Tony Vroon <tony@vroon.org> wrote:
> On Wed, 2008-10-22 at 14:48 +0300, Felipe Contreras wrote:
>> I've been trying 2.6.27 and 2.6.27.2, and I haven't been able to use
>> the e1000 module.
>
> Perhaps your device is new enough to be PCI-express, and as such needs
> the new e1000e driver? I would advise to have both drivers enabled or
> modular, so you can try which one works.
> (It is true that the e1000 driver attached to some PCIe hardware in the
> past, this has been changed)

Hehe, yeap, that was it.

Thanks.

-- 
Felipe Contreras
