Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbZAIXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbZAIXYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbZAIXXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:23:53 -0500
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:47997 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932880AbZAIXXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:23:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jEI2CA6+Q0Ns1ZQ/eEVmexGyomLCQi114qhwXBJbPqxHwKfE8P4ANENqcDSkWYQYzRlPqwX3I3qCIBtDTjIgSOiWQ1SZRkprnOZ4Jy0ZPlLH/g4vZX4Qez8QSRn8CG4i;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3/8] PCI PCIe portdrv: Remove unused device extension
Date: Fri, 9 Jan 2009 15:23:49 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042351.07144.rjw@sisk.pl>
In-Reply-To: <200901042351.07144.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091523.49589.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 2:51 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> There is struct pcie_port_device_ext defined in portdrv.h, but its
> member is only initialized and never used.  Remove it.

Yay for dead code elimination.

-- 
Jesse Barnes, Intel Open Source Technology Center
