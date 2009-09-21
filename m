Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZIUHGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZIUHGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZIUHGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:06:42 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:45673 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZIUHGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:06:41 -0400
MIME-Version: 1.0
In-Reply-To: <20090920122411.GA5413@n2100.arm.linux.org.uk>
References: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
	 <20090919110316.GA23452@n2100.arm.linux.org.uk>
	 <20090920081550.GA830@n2100.arm.linux.org.uk>
	 <cc557aab0909200235sbb4c1f5tdc84434732222988@mail.gmail.com>
	 <20090920122411.GA5413@n2100.arm.linux.org.uk>
Date: Mon, 21 Sep 2009 10:06:42 +0300
Message-ID: <cc557aab0909210006n2f423bf9lf208e355bed0fada@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 3:24 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Sep 20, 2009 at 12:35:19PM +0300, Kirill A. Shutemov wrote:
>> Ok, so __do_page_fault() should know where we are: in data abort or in
>> prefetch abort. What is right way to do it? Should we create one more
>> argument or use one of reserved bits IFSR?
>
> Well, this is my solution to the problem - could you test it please?

Yes, it works. But I still think that ignoring IFSR is a mistake. I'll send
updated patches
