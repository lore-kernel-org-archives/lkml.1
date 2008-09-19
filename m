Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYISV5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYISV5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYISV5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:57:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:11862 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbYISV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hmvprPnQqqoCUAIeVULgPHrW1eimdMcbANemCrHZDN+Q48j46T1x8V+uhh4s9sHhc2
         3MKpT7iNIKH9YnyBf9CMVuFJnZxpEPyEkN75aneiGgfHRJupC9ORlDVviNWomrBC/cPm
         T7zqKlVfqjrfEDlSufMWmmOX7IIOxqw/zugao=
Message-ID: <86802c440809191457g19e2cbbeo26aa3dff613b057f@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:57:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Chris Li" <lkml@chrisli.org>
Subject: Re: irq 19: nobody cared
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <70318cbf0809191340t4e9d4caft6656713576cd2084@mail.gmail.com>
	 <86802c440809191350h21327c76l55d2134d7667f5d0@mail.gmail.com>
	 <70318cbf0809191413v70c49eccq9ed16ae50864a1a5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 2:13 PM, Chris Li <lkml@chrisli.org> wrote:
> On Fri, Sep 19, 2008 at 1:50 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> can you boot with pci=earlydump ?
>>
>> YH
>>
>
> Here we go. I attached the new dmesg with pci=earlydump.
>

0x1a.2
0x1d.1
0x1f.2
0x1f.5

are sharing pin 0x19...

but early dump can not find 0x1a.2, 0x1f.2, 0x1f.5

YH
