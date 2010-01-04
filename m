Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526Ab0ADQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0ADQei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464Ab0ADQef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:34:35 -0500
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:43250 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753417Ab0ADQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:34:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=itK02JDS8ZQcomc2DQPBbKU182CeB0zKyr2B2+TiR/aFV/Ce5ls/lnYp71i54FDjLtMJjPv11JR3F4yXjalLAGl9J6MpVGMz9UQjhRsBUvHfIXCUIZk/4r+EQ5HQGh0G;
Date: Mon, 4 Jan 2010 08:34:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Youquan,Song" <youquan.song@linux.intel.com>
Cc: andi@firstfloor.org, ying.huang@intel.com, kent.liu@intel.com,
       youquan.song@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]PCIe AER: fix aer inject result in kernel oops
Message-ID: <20100104083429.1fc02c04@jbarnes-piketon>
In-Reply-To: <20091211234235.GA7196@youquan-linux.bj.intel.com>
References: <20091211234235.GA7196@youquan-linux.bj.intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 18:42:35 -0500
"Youquan,Song" <youquan.song@linux.intel.com> wrote:

> If BIOS does not export _OSC to allow OS take over the PCIe AER, pcie
> aer driver will not initialize aer service. But aer_inject driver
> does not check this scenario, it results in kernel oops when inject
> aer error to OS. Some of kernel oops information as following:

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
