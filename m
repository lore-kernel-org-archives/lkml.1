Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab0CAKne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:43:34 -0500
Received: from poutre.nerim.net ([62.4.16.124]:64715 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0CAKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:43:33 -0500
Date: Mon, 1 Mar 2010 11:43:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: linux-next: build failure after merge of the i2c tree
Message-ID: <20100301114330.43621d4f@hyperion.delvare>
In-Reply-To: <20100301131231.4c541979.sfr@canb.auug.org.au>
References: <20100301131231.4c541979.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 1 Mar 2010 13:12:31 +1100, Stephen Rothwell wrote:
> Hi Jean,
> 
> After merging the i2c tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/i2c/busses/i2c-powermac.c: In function 'i2c_powermac_smbus_xfer':
> drivers/i2c/busses/i2c-powermac.c:125: error: 'err' undeclared (first use in this function)
> 
> Caused by commit 2fe61c97a4b1be56d93a84992ffcf00d55f60f63 ("i2c-powermac:
> Be less verbose in the absence of real errors").
> 
> I have used the i2c tree from next-20100226 for today.

Oops, I am very sorry, thanks a lot for reporting. This is fixed now,
sorry for the annoyance.

-- 
Jean Delvare
