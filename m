Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZISLD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZISLD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZISLD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:03:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42932 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbZISLD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:03:26 -0400
Date: Sat, 19 Sep 2009 12:03:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
Message-ID: <20090919110316.GA23452@n2100.arm.linux.org.uk>
References: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f73fa56a41bc1051cd347cc453081235e3d776.1253307263.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 11:55:42PM +0300, Kirill A. Shutemov wrote:
> It needed for proper prefetch abort handling on ARMv7.

I think the only thing which is missing is an explaination about why
this is desirable given that only later CPUs can give this additional
information.
