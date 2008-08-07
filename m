Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYHGQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYHGQvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYHGQvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:51:01 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:43156 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751861AbYHGQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:51:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=M/8EOstkQaX9HtnNrpa7R6gpqCjXliOZqIcDIe8LdyVG9N5Y1bUU71Qd2/qYltSsUVRILgTG556wDoRB5sYXJhPRKwxr3rj3ysrEQfQR1T5cVt7A//rLwLeDDQebYAis;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [patch] PCI: check the return value of device_create_bin_file() in pci_create_bus()
Date: Thu, 7 Aug 2008 09:50:50 -0700
User-Agent: KMail/1.9.9
Cc: Michael Ellerman <michael@ellerman.id.au>, Matthew Wilcox <matthew@wil.cx>,
       Sven Wegener <sven.wegener@stealer.net>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080805111406.GA13899@verge.net.au> <20080807010615.GB24761@verge.net.au> <20080807045632.GA2018@verge.net.au>
In-Reply-To: <20080807045632.GA2018@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070950.51400.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 6, 2008 9:56 pm Simon Horman wrote:
> Check the return value of device_create_bin_file in pci_create_bus and
> unwind if necessary. Don't propagate error to caller, as failure to create
> these files shouldn't prevent PCI from being initialised. Instead, just
> log a warning.
>
> Cc: Sven Wegener <sven.wegener@stealer.net>
> Cc: Michael Ellerman <michael@ellerman.id.au>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Signed-off-by: Simon Horman <horms@verge.net.au>

Applied, thanks for your persistence, Simon! :)

Thanks,
Jesse
