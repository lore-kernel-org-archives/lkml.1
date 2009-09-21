Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZIUQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZIUQfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZIUQfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:35:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZIUQfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:35:40 -0400
Date: Mon, 21 Sep 2009 17:35:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Koskinen Aaro <aaro.koskinen@nokia.com>
Subject: Re: [PATCH v4 2/2] ARM: Proper prefetch abort handling on ARMv6
	and ARMv7
Message-ID: <20090921163531.GE30821@n2100.arm.linux.org.uk>
References: <490fc9117572828816ebfec0200d7aad9e91075b.1253557409.git.kirill@shutemov.name> <8f6baf3261f6bde5b50142cbdf48b2e9e0821892.1253557409.git.kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f6baf3261f6bde5b50142cbdf48b2e9e0821892.1253557409.git.kirill@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:24:09PM +0300, Kirill A. Shutemov wrote:
> Currently, on ARMv6 and ARMv7, if an application tries to execute
> code (or garbage) on non-executable page it hangs. It caused by
> incorrect prefetch abort handling. Now every prefetch abort
> processes as a translation fault.

Please ensure that your patches apply on top of this set of patches:

http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/arm.diff

Thanks.
